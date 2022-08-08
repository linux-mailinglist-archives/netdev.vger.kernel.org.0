Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD5958CA36
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 16:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242879AbiHHOMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 10:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236032AbiHHOMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 10:12:15 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94963BF
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 07:12:14 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so9207524pjf.2
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 07:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=+/nfGYDOiyq9i8n1KnyJRPRi4g+jbVgntX/q7vC1EFk=;
        b=PRjtIIU/nwfZtoJpNsQ9pKru7NSsnWrfYSBqwKp2UscjfAqTZc4UhCR6nNSopMT6GM
         kY+wZf6uvEorQLSk2bO2EcRdEjqsvjQYYSqaNgrMcKMZ9HSpXjGcHHhgIhWc3k7O6ewj
         UwELYN3ypSoLWlsx7g/6vxXhYhrGelsUK7NucYGCksHNrQYtcflhiVCG5XRqe6I1X679
         29esjZHsi2oI9Z/fOnB5FuXX1l0vMCWO0G0cpn1uDqnpReOwvr2ENn7871eRA44KwcqC
         wb4bjqw7mg9dBbv0ZA5agoM39cywlNZKRvDMn3QKaPhnRjMf7+C8giK5O0Q9jOyoTB/3
         9A5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=+/nfGYDOiyq9i8n1KnyJRPRi4g+jbVgntX/q7vC1EFk=;
        b=bVRHiDpFHJeo6Bxba/Hk8Z0JBTJEdd3gTQF0UoVffiFhSxUpglIcyJ38BAWE0KmXWD
         juai7x5emUZSASoDwLtDjswjottSGZWmgux6FtqrNdQ+dfhG0MAtDJztqkRnRGylTuAk
         awefwh/b+hM2JF9bF+utjxE4Nt4cmGKY6hgycsp25LtFG/mf3E55nj6Ytwiur7tyHoOc
         Ii40tn93oaeNfx8UpnCHDBKQ1FvnPfsdZ+e3LasekWt3MTefJxLRClQxtQtADqSLzDdA
         yhXZAvuGLIgTziyxBdUc3FapUxDDFVFHjiXZ0Zps6P6ufDYfKUm9EPxPRoA5Y+iNIy0+
         CHQw==
X-Gm-Message-State: ACgBeo3LtqqxYMoNyNhfc6jgZA/OSI9Ih0KcT2coWYkAbMqR9RSD9mN3
        nFwd9MDnpG4Z9z8eOWrVY0BsadWKLSQ=
X-Google-Smtp-Source: AA6agR6vvluAeqSyOLXswyNUCOojZ2UWxqJY3MAl7TdSM4jdpssyHo2caqb/r6SMuxW9U8cH7a20ZQ==
X-Received: by 2002:a17:902:e94e:b0:16d:12b6:b9fe with SMTP id b14-20020a170902e94e00b0016d12b6b9femr18828549pll.152.1659967934481;
        Mon, 08 Aug 2022 07:12:14 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 22-20020a621616000000b0052f1e061b21sm3841635pfw.66.2022.08.08.07.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 07:12:14 -0700 (PDT)
Date:   Mon, 8 Aug 2022 07:12:12 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] fec: Allow changing the PPS channel
Message-ID: <YvEZvCmS9lSoyhDQ@hoboy.vegasvil.org>
References: <20220808131556.163207-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220808131556.163207-1-csokas.bence@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 08, 2022 at 03:15:57PM +0200, Csókás Bence wrote:
> +static ssize_t pps_ch_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct net_device *ndev = to_net_dev(dev);
> +	struct fec_enet_private *fep = netdev_priv(ndev);
> +	int enable = fep->pps_enable;
> +	struct ptp_clock_request ptp_rq = { .type = PTP_CLK_REQ_PPS };
> +
> +	if (enable)
> +		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 0);
> +
> +	kstrtoint(buf, 0, &fep->pps_channel);
> +
> +	if (enable)
> +		fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);

NAK.

Don't use a private, custom sysfs knob.  The core PTP layer provides
an API for that already.

Thanks,
Richard

> +
> +	return count;
> +}
