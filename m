Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACC8604F4F
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiJSSFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiJSSFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:05:04 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24494103D89;
        Wed, 19 Oct 2022 11:05:00 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id q19so26437269edd.10;
        Wed, 19 Oct 2022 11:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CPCOCKDfIDxOtTuewZ2m3mRc5xfkqduD2wdXQdx/mU8=;
        b=ADPgwAJul1OCbsvtdmeFw6IGxJwMsW7s6Z60UjjwUmHcVxToOQymVLgZjdB3rEdu1w
         Vfk6CSiDib1FMO0hzFi682a48+jkr/vKdcYk2StZzt24K18SfGLjbzQHVgrmRQDKemj6
         CHuvQXlKFdzFfyqhi2R3f9opfnscREE/zZ9hqld/9HZ/sDn/kVn08pQUpq3ABwO36UVA
         ZsFedh35SR04fyaWgsN+5xjC92uH6xrIbFlxpKQRU1BpLwUimvIRB9sPVDWzLHIBsQQo
         Xkg+HNWRnBBhZPRcnNzGRoXBltZmWCPaApvTVoEzqEnwBG1GcHzlh+Kw+t9TC79nRLlC
         ZRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CPCOCKDfIDxOtTuewZ2m3mRc5xfkqduD2wdXQdx/mU8=;
        b=4Frg2gKxsa8Sw6m22KKeItTY6QfBzpyK1r6b3NlCFFQutuIjdarZ/5kmDoZmMnjRhd
         9N8cmHYJ/WgkuLTX4MWn1kiW+YSWM7zzk07NHxJgs6k55FnX1/VheILlejfsS9mrxqWd
         iPPbLDwBdp5TPXP+GfuN3URVtqiHf4PgXG85UEaUs8s7PXAqe0LBDLEZNHSPqiiUzDlN
         ILNm8m2bAvRX+i9reQNWtSJDeCw+vKfQupFXpBJOR3phMG4rm+ZTRg/Hu/+XnlTknCIF
         YYJ99UyhUMhz+KBaDcXJODBubINIrS3nT8gHZNYifvLI3u2NsV5KaoRd23W66npV1Asn
         WNQg==
X-Gm-Message-State: ACrzQf0KT78H8x7aZZZXJ5hmJ8dQ8bZ2CTs6M9LtFCEN5/jwjORBWYcU
        kQ3yIqUz0yYk7m89c2w5NRfZ/kWADaiMYQINlvM=
X-Google-Smtp-Source: AMsMyM7GvA8sQUMYJHDTFwGgo06J+MYNgjMZHwRVsiAiC+LNDbveBY8taH7bT3l+WUxX1TaIpqBtX7WNYz6KwmrZFg4=
X-Received: by 2002:aa7:cad5:0:b0:454:88dc:2c22 with SMTP id
 l21-20020aa7cad5000000b0045488dc2c22mr8708435edt.352.1666202698415; Wed, 19
 Oct 2022 11:04:58 -0700 (PDT)
MIME-Version: 1.0
References: <20221019132503.6783-1-dnlplm@gmail.com> <87lepbsvls.fsf@miraculix.mork.no>
In-Reply-To: <87lepbsvls.fsf@miraculix.mork.no>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Wed, 19 Oct 2022 20:04:47 +0200
Message-ID: <CAGRyCJH0sZx3PqVxjpSo06Gnf2z69j1zGLKZ3_yvrDpxkEEeOA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] net: usb: qmi_wwan implement tx packets aggregation
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il giorno mer 19 ott 2022 alle ore 17:04 Bj=C3=B8rn Mork <bjorn@mork.no> ha=
 scritto:
>
> Daniele Palmas <dnlplm@gmail.com> writes:
>
> > I verified this problem by using a MDM9207 Cat. 4 based modem (50Mbps/1=
50Mbps
> > max throughput). What is actually happening is pictured at
> > https://drive.google.com/file/d/1xuAuDBfBEIM3Cdg2zHYQJ5tdk-JkfQn7/view?=
usp=3Dsharing
> >
> > When rx and tx flows are tested singularly there's no issue in tx and m=
inor
> > issues in rx (a few spikes). When there are concurrent tx and rx flows,=
 tx
> > throughput has an huge drop. rx a minor one, but still present.
> >
> > The same scenario with tx aggregation enabled is pictured at
> > https://drive.google.com/file/d/1Kw8TVFLVgr31o841fRu4fuMX9DNZqJB5/view?=
usp=3Dsharing
> > showing a regular graph.
>
> That's pretty extreme.  Are these tcp tests?  Did you experiment with
> qdisc options? What about latency here?
>

Yes, tcp with iperf. I did not try qdisc and haven't measured (yet) latency=
.

> > This issue does not happen with high-cat modems (e.g. SDX20), or at lea=
st it
> > does not happen at the throughputs I'm able to test currently: maybe th=
e same
> > could happen when moving close to the maximum rates supported by those =
modems.
> > Anyway, having the tx aggregation enabled should not hurt.
> >
> > It is interesting to note that, for what I can understand, rmnet too do=
es not
> > support tx aggregation.
>
> Looks like that is missing, yes. Did you consider implementing it there
> instead?
>

Yes, I thought about it, but it's something that has a broader impact,
since it's not used just with usb, not really comfortable with that
code, but I agree that's the way to go...

> > I'm aware that rmnet should be the preferred way for qmap, but I think =
there's
> > still value in adding this feature to qmi_wwan qmap implementation sinc=
e there
> > are in the field many users of that.
> >
> > Moreover, having this in mainline could simplify backporting for those =
who are
> > using qmi_wwan qmap feature but are stuck with old kernel versions.
> >
> > I'm also aware of the fact that sysfs files for configuration are not t=
he
> > preferred way, but it would feel odd changing the way for configuring t=
he driver
> > just for this feature, having it different from the previous knobs.
>
> It's not just that it's not the preferred way.. I believe I promised
> that we wouldn't add anything more to this interface.  And then I broke
> that promise, promising that it would never happen again.  So much for
> my integrity.
>
> This all looks very nice to me, and the results are great, and it's just
> another knob...
>
> But I don't think we can continue adding this stuff.  The QMAP handling
> should be done in the rmnet driver. Unless there is some reason it can't
> be there? Wouldn't the same code work there?
>

Ok, I admit that your reasoning makes sense.

There's no real reason for not having tx aggregation in rmnet, besides
the fact that no one has added it yet.

There's some downstream code for example at
https://source.codeaurora.org/quic/la/kernel/msm-4.19/tree/drivers/net/ethe=
rnet/qualcomm/rmnet/rmnet_handlers.c?h=3DLA.UM.8.12.3.1#n405

I can try looking at that to see if I'm able to implement the same
feature in mainline rmnet.

Thanks for your comments!

Regards,
Daniele

> Luckily I can chicken out here, and leave final the decision to Jakub
> and David.
>
>
>
> Bj=C3=B8rn
