Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A9F5FDD60
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJMPog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJMPoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:44:19 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E937260C9A
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:43:46 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id t12-20020a17090a3b4c00b0020b04251529so2218096pjf.5
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=98MaKDG0/gn8pwPgms8yBHMXesJ3YVR8idlVG+WVD9M=;
        b=eGIuKe/RFHRSTTf8w199c5UcIRbXMqchpiMNyIw56J2PrS+SCUMhvcE3l4nRp8dUJT
         DtOXcQuvZ7lxaBesaYi2grqKm4zwtgb2Dv1Wjpzy6qWfkylT68ljQJamDUjzYtJCbk0+
         gDkEqkzavhXvCw2m7M32ZgTI8WG12WVCTXDMR87pzaPEkXkIpicbJ8za6CnVnZMMXGon
         9bh0Rx2kAEQwYjGRfJ1IkrBpVn12QUBYeC4NwP/aY5yXZhKlS8+jZ+8sMXL+nUnNR7y+
         y1tWTBsAzQtvKyC9ZndOIc8Mz3HT6B0qbAAoS1M+Fmilqla51uv1kp96cJi3ZaTIwMBM
         vLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=98MaKDG0/gn8pwPgms8yBHMXesJ3YVR8idlVG+WVD9M=;
        b=dtsuoibENx5E0blQ4TnFvp3ELQSHrs53ZyQaVg6YmDCBCHSFLX2Kgb2cZnyNXKIqv3
         QVmVV0UgpPxkYxCm1WKB3q0AUoCfHdQzVRKD0CS6AvukuL3r1j2eAuN/OQXxNz50KG77
         sua/S1WAq8rY7vgX7Y3OvS80prFKlcYMuvfywX865yCmJhV1hg1Y6IPvG+IV4I8Cjq/s
         OcyOQeRZqjBrjznA+DVUgQPfR49h+ks4qzQS2A+IbWX1ERoUSZEBqNbmjByjQv0SZwlx
         KOI2gsqMtfN4jIXtSQE0sv/Xvr9WXB+/tiGe7zYYPZq14T56PhgmYVTC8kW6AHunqIkg
         Ot8g==
X-Gm-Message-State: ACrzQf2IedefElG7DlJuHCW2Cb10TTstQWt5eN3Tr3U8rLhK7oV/YXRF
        RunKOGT9MF9wbnhdVPwLwdqwrS6eMQF/ug==
X-Google-Smtp-Source: AMsMyM7/521VbeeMq8ThKaxMju1RBewR8rTpgJhP363l7hAu7l+1Pn2AjYpfTvwhLsYR+VW32S1+Iw==
X-Received: by 2002:a17:90b:4d0d:b0:20d:6fc0:51 with SMTP id mw13-20020a17090b4d0d00b0020d6fc00051mr5940102pjb.10.1665675826418;
        Thu, 13 Oct 2022 08:43:46 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id x17-20020a17090a531100b0020a7d076bfesm3389040pjh.2.2022.10.13.08.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 08:43:46 -0700 (PDT)
Date:   Thu, 13 Oct 2022 08:43:44 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     Christian =?UTF-8?B?UMO2c3Npbmdlcg==?= <christian@poessinger.com>,
        netdev@vger.kernel.org
Subject: Re: iproute2/tc invalid JSON in 6.0.0 for flowid
Message-ID: <20221013084344.0fe8f3de@hermes.local>
In-Reply-To: <Y0gsNeByeUnTF3AT@electric-eye.fr.zoreil.com>
References: <f4806731521546b0bb7011b8c570b52b@poessinger.com>
        <Y0gsNeByeUnTF3AT@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Oct 2022 17:18:13 +0200
Francois Romieu <romieu@fr.zoreil.com> wrote:

> Christian P=C3=B6ssinger <christian@poessinger.com> :
> [...]
> > If you can point me to the location which could be responsible for this=
 issue, I am happy to submit a fix to the net tree. =20
>=20
> If the completely untested patch below does not work, you may also
> dig the bits in include/json_print.h and lib/json_print.c=20
>=20
> (Ccing Stephen as the unidentified "both" in README.devel)
>=20
> diff --git a/tc/f_u32.c b/tc/f_u32.c
> index d787eb91..70098bcd 100644
> --- a/tc/f_u32.c
> +++ b/tc/f_u32.c
> @@ -1275,11 +1275,11 @@ static int u32_print_opt(struct filter_util *qu, =
FILE *f, struct rtattr *opt,
>  		fprintf(stderr, "divisor and hash missing ");
>  	}
>  	if (tb[TCA_U32_CLASSID]) {
> +		char *fmt =3D !sel || !(sel->flags & TC_U32_TERMINAL) ? "*flowid %s" :=
 "flowid %s";
>  		SPRINT_BUF(b1);
> -		fprintf(f, "%sflowid %s ",
> -			!sel || !(sel->flags & TC_U32_TERMINAL) ? "*" : "",
> -			sprint_tc_classid(rta_getattr_u32(tb[TCA_U32_CLASSID]),
> -					  b1));
> +
> +		print_string(PRINT_ANY, "flowid", fmt,
> +			    sprint_tc_classid(rta_getattr_u32(tb[TCA_U32_CLASSID]), b1));
>  	} else if (sel && sel->flags & TC_U32_TERMINAL) {
>  		print_string(PRINT_FP, NULL, "terminal flowid ", NULL);
>  	}
>=20


Already sent patch.
