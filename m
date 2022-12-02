Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A93640610
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 12:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbiLBLtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 06:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbiLBLtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 06:49:33 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6793C3FD4
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 03:49:32 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id o13so11014170ejm.1
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 03:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r7uLAAs4bO1HpAj/DZeL/+OcigOa7n9nPnD6K/njkOA=;
        b=XFXujQ2A+9x4wDF3mXds8l48zBENVCOFYrXs7x5TS+3iXBljtOCAsjPGpvg+e5Nlp+
         h+C2SsoGVt9yeHID9/iNb290ucUJAMx1zynfdac4sMRyN8rcDVa23iZC1f0ag+6+edZJ
         mHQ0PTMKmmyp9yGaS+STGJLrlqwEmTEda1qdOhmUV5PGpQRqRFhQ3vVpxTn7s7LgV0t1
         Ln61GyIN47LUJTmGT/7nWz8H2b/qGoPcmAE4q/HOHDquiN2sbBWhM3sH+jR3cvEyxP9j
         M547O/e26j1emjrC0GTHjVPVfdr2gBRUGVb0cj7l7FZrfqO/sbCDKWLIiqHtDKXO2Ws/
         lIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r7uLAAs4bO1HpAj/DZeL/+OcigOa7n9nPnD6K/njkOA=;
        b=GbwOzueoSpBJ6zt+PLdzVk5CL34aQuXyXjBjnubgN+KgVJ6vtEObJQ5jHUrJL+Rf2c
         befmKVFHT/3dmXeqTseB5EyghruRWfSQtgCIGjq088w5Eu0iUmDEQYovrCOKqDdz+sYv
         u50+l4/435hnxDT+Tj7ILL2wGfUvRYOssSdzkbc7XNfqAjr7KAbhB/v9PL6QufgxvSxT
         MtVUwbJQl4Zq68W1FGu2/UnGQqpb2OIcECBWKGQGktH1+Vg+MSiAgfjTSIjI00xwBxOt
         DiGHgETkcP0SVBW/XVU3mFzRC8uPR9ifF8WKrjp+cPdWkQcU+2PGtIJD6r4BUsUVVxeI
         Wkkg==
X-Gm-Message-State: ANoB5pkkB+X58VRtCn9nn/9Pt7U4x//cFQzn1vKiAtuisc3xVRJlLnAf
        CGwmS1sUaK+F5Woqj1fUf3awsS5mLBclqroWuDg=
X-Google-Smtp-Source: AA0mqf7Lm9DJQEfm/7WO32m1FmyD2Fw021yFo98G/sQguUfyE+LU56z2kidr+7u6Ftc7SANi5UBSmqSaiObZKgY4Wd0=
X-Received: by 2002:a17:906:a259:b0:7ad:ccae:a30d with SMTP id
 bi25-20020a170906a25900b007adccaea30dmr46127820ejb.704.1669981771117; Fri, 02
 Dec 2022 03:49:31 -0800 (PST)
MIME-Version: 1.0
References: <20221130124616.1500643-1-dnlplm@gmail.com> <20221130124616.1500643-2-dnlplm@gmail.com>
 <20221201162131.1f6c6188@kernel.org>
In-Reply-To: <20221201162131.1f6c6188@kernel.org>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Fri, 2 Dec 2022 12:42:50 +0100
Message-ID: <CAGRyCJHMASBF1QVys_Pi62Mi0pCu1oft=zBsT5s_GbXxY_yuRg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] ethtool: add tx aggregation parameters
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

Il giorno ven 2 dic 2022 alle ore 01:21 Jakub Kicinski
<kuba@kernel.org> ha scritto:
>
> On Wed, 30 Nov 2022 13:46:14 +0100 Daniele Palmas wrote:
> > Add the following ethtool tx aggregation parameters:
>
> > diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> > index bede24ef44fd..ac51a01b674d 100644
> > --- a/Documentation/networking/ethtool-netlink.rst
> > +++ b/Documentation/networking/ethtool-netlink.rst
> > @@ -1002,6 +1002,9 @@ Kernel response contents:
> >    ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
> >    ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
> >    ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
> > +  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES``     u32     max aggr packets size, Tx
> > +  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES``    u32     max aggr packets, Tx
> > +  ``ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS``    u32     time (us), aggr pkts, Tx
> >    ===========================================  ======  =======================
>
> Please double check make htmldocs does not generate warnings.
> I think you went outside of the table bounds (further than
> the ==== line)...

Oddly, in my system I don't see any warning related to
ethtool-netlink.rst when doing make htmldocs, I will send anyway a v3
with changes to stay inside the table bounds.

Thanks,
Daniele
