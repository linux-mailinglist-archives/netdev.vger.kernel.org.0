Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3380C60E6A2
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 19:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbiJZRgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 13:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiJZRgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 13:36:38 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DB36567;
        Wed, 26 Oct 2022 10:36:37 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id o12so30192016lfq.9;
        Wed, 26 Oct 2022 10:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GOBxO2vTj4pQ4aIbyzSDDJOcDDeM1TEViOD8cCWt4BY=;
        b=YJ/QJUMubvUEs1kkmB6WihInHwiD6FV3O6Ifh2QzAVOjzezDSzxfJaTKgNMNDwLMys
         Kz2vIYoYk8dgxtvyDC4LG08oOCwqHN3+gMG03ZUh/0YNSXHkO/2CAEkE0mlkUoDiQUaq
         goBalu2lRkjO5rGdTuyGLGWkViMOJvy40eVncP5EroDYj/D82rZhIrX/0qCvX6TyDYGM
         6kONH+kWwAgIIGvK/gHX5BS/68BAMEaR8zLf/KE6AnS2R/ROydwimiNKLrQWUz7+YLSl
         YYeQoZyooY+uclKbVkxI21Da5qQw6TlRSzQPv+cZIeDTPKQf3KEf1npycUj9yUgdkTHY
         mIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GOBxO2vTj4pQ4aIbyzSDDJOcDDeM1TEViOD8cCWt4BY=;
        b=1ih6LN/A0v3K4BISmeb2GP+06Ltf5Fb8KAZ7vifXLj4WwkNxJnBy1ObY6wl23lTOyO
         v9yFONbQyuaMOLCDKboLBtxGjknQlgzOGucjLl4POWjkRgYBYOeWuEMUYv+2NME/qetn
         jaoxsj3GS5/6ou2FE4svUgIe6s8qyIbNUONDXvpGygW+IllZZtG6TE4QIPbJvmEFXxNH
         28huO5TOUcfIR2YUNEvdRorIt2Nibhot3Z25t86DtMMv/YQ2ErpAWR089SJIyrEeQ2kc
         IdY9pSzvAtIzmblNUlTpXORfQei3N/0ip4/cCqcFhLnTe4CEt3vVBgwu8724znC0cUet
         CT2A==
X-Gm-Message-State: ACrzQf08dv2H8E6HXv1YzgpcGnguG5Gm0fkU4shoLMBfjazrGlGWxIBu
        GFHI5dZGes4V0gAecvmK9oI=
X-Google-Smtp-Source: AMsMyM7graN5LI/64DZqEGICp6VHlD/7djtr6oZe2CFM3fq1Ao1iFbuJbwrbvjpRuB0qFhw2Z3Emng==
X-Received: by 2002:ac2:4c82:0:b0:4a0:5825:a0ac with SMTP id d2-20020ac24c82000000b004a05825a0acmr15859970lfl.660.1666805795020;
        Wed, 26 Oct 2022 10:36:35 -0700 (PDT)
Received: from smtpclient.apple (188-177-109-202-dynamic.dk.customer.tdc.net. [188.177.109.202])
        by smtp.gmail.com with ESMTPSA id a11-20020a19e30b000000b0048a757d1303sm911652lfh.217.2022.10.26.10.36.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Oct 2022 10:36:34 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] Periodically flow expire from flow offload tables
From:   Michael Lilja <michael.lilja@gmail.com>
In-Reply-To: <Y1kQ9FhrwxCKIdoe@salvia>
Date:   Wed, 26 Oct 2022 19:36:22 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <25246B91-B5BE-43CA-9D98-67950F17F0A1@gmail.com>
References: <20221023171658.69761-1-michael.lilja@gmail.com>
 <Y1fC5K0EalIYuB7Y@salvia> <381FF5B6-4FEF-45E9-92D6-6FE927A5CC2D@gmail.com>
 <Y1fd+DEPZ8xM2x5B@salvia> <F754AC3A-D89A-4CF7-97AE-CA59B18A758E@gmail.com>
 <Y1kQ9FhrwxCKIdoe@salvia>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I will look to use the flowable netlink interface. I have not yet, but =
does this possible give the option of doing something like this:

flowtable ft {
	hook ingress priority filter
	devices =3D { lan1, lan2, wan }
	flags offload, timeout
}


I would say the above it the most flexible, I just didn=E2=80=99t =
explore that, it would kinda be like with =E2=80=99sets=E2=80=99 where =
you can specify a timeout on when the entries should expire?


With regards to the IPS_OPPLOAD clear in flow_offload_del() then I added =
that because I saw some weird timeout side effects due to =
flow_offload_fixup_ct(), but I can re-investigate, it could be that it =
was early in my investigations and some of the other changes I made has =
made it obsolete.

Thanks
Michael

