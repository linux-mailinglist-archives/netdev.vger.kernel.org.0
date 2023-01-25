Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C3067A837
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 02:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjAYBEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 20:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjAYBES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 20:04:18 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EDF530EC;
        Tue, 24 Jan 2023 17:03:54 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id g14so18647113ljh.10;
        Tue, 24 Jan 2023 17:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+n01u9NXtWcuGWgAPYEZfG87R2VPeQABZEmCZNZy7Ks=;
        b=HBCuX9pXxLTHsYqFePasL0AEPRmLXa0YRu3t8+wIimZC+QLNDYeCBDDOnC4iy3Bb44
         ZFxOrT4EcBGOtESECnVRBGb6X8GhJ6nDB28f1VcuzbERT5a+pej+B8J4101b4I3MP3yb
         K1R4IYnkWJ3xXPMg40cGQ846lxzBaSDHUPHu2qZ2TW9YDDzD8BrlT8rhW071hYfAZsZs
         NGJP624w9tmkKrBpNR9gF6ku/MLtM0g6YOy89wynOHQztnbqNCz/8VafsMvee+uJ2CP+
         R/+xsXUkLB2ZCPM6wXe2l+ScKN/yjIWPK8ofAoQbQpAhEs8F42yvu//4hMAp/gy+BJbw
         iblg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+n01u9NXtWcuGWgAPYEZfG87R2VPeQABZEmCZNZy7Ks=;
        b=Up18YWvd1/wkLENmsK6hzEvXj0okiRGrf/3iw74OGBERBOjUYOKAQN4vCdkzXISR79
         isiRqSOzc3kqGwfHklpMvrh4mZDlkq0FzLrbaew6LIFJGSmJKRYvF66mev92ga9squBP
         QfzMg04aAw3mEpbJko/emHih8+L7JnsTeJ0IqDkO5ttva2qV508YJY3pogkgJ+lqQmE8
         8CGlMaw3ifKuMsOFSvRb7Z2NVG2Ii+ieQ4e8DExDisZuObqadZ+nPhWV8Fk5iut8Zb1I
         iB7EhCHTkOow2mKc+LztgjryiQFZbVceFYOGIB+Wh3IT0bU/NBIqsGD8aGoB11WpqZjT
         R5zg==
X-Gm-Message-State: AFqh2krDqgU3aJsmBf/O89a2eYUr14HnWcZsKoT6KGYNbrFm54evh+lE
        zAzw8d2SBicqsDxcPk7BXpv5umJJYDm8sFWvxN0=
X-Google-Smtp-Source: AMrXdXs3/97nZJqGIZCdAk2Lr/mMkpuqxNBScacxcEE9J2bNRl6LUVLx2X9lOu9oSZN3BN9Ma34T0Wbd3DsEpIdGoZI=
X-Received: by 2002:a2e:9212:0:b0:28b:63dc:4c7 with SMTP id
 k18-20020a2e9212000000b0028b63dc04c7mr1626927ljg.423.1674608629060; Tue, 24
 Jan 2023 17:03:49 -0800 (PST)
MIME-Version: 1.0
References: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com>
 <20230124174714.2775680-3-neeraj.sanjaykale@nxp.com> <167458712396.1259484.1395941797664824881.robh@kernel.org>
 <CABBYNZKAwp3Wqjrcp4k3wvjZSNfJhRWA5ytH7oNWXCG7V4k2ow@mail.gmail.com> <CAL_JsqJged+SwGy5b1w2Cx-dV06=LKb1mX9ykN7GrpR6P4gUVw@mail.gmail.com>
In-Reply-To: <CAL_JsqJged+SwGy5b1w2Cx-dV06=LKb1mX9ykN7GrpR6P4gUVw@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 24 Jan 2023 17:03:37 -0800
Message-ID: <CABBYNZJusgf7vQU4g6zvOLj2dsJ7Pf1A6k2myjpzW+JKkw+sQw@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth support
To:     Rob Herring <robh@kernel.org>
Cc:     Tedd Ho-Jeong An <hj.tedd.an@gmail.com>,
        Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
        jirislaby@kernel.org, sherry.sun@nxp.com, marcel@holtmann.org,
        linux-serial@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        rohit.fule@nxp.com, devicetree@vger.kernel.org,
        amitkumar.karwar@nxp.com, linux-bluetooth@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        johan.hedberg@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Tue, Jan 24, 2023 at 3:08 PM Rob Herring <robh@kernel.org> wrote:
>
> On Tue, Jan 24, 2023 at 3:44 PM Luiz Augusto von Dentz
> <luiz.dentz@gmail.com> wrote:
> >
> > Hi Rob, Tedd,
> >
> > On Tue, Jan 24, 2023 at 11:06 AM Rob Herring <robh@kernel.org> wrote:
> > >
> > >
> > > On Tue, 24 Jan 2023 23:17:13 +0530, Neeraj Sanjay Kale wrote:
> > > > Add binding document for generic and legacy NXP bluetooth
> > > > chipset.
> > > >
> > > > Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> > > > ---
> > > >  .../bindings/net/bluetooth/nxp-bluetooth.yaml | 67 +++++++++++++++++++
> > > >  1 file changed, 67 insertions(+)
> > > >  create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
> > > >
> > >
> > > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > >
> > > yamllint warnings/errors:
> > > ./Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml:67:1: [warning] too many blank lines (2 > 1) (empty-lines)
> > >
> > > dtschema/dtc warnings/errors:
> > > Error: Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.example.dts:18.9-15 syntax error
> > > FATAL ERROR: Unable to parse input tree
> > > make[1]: *** [scripts/Makefile.lib:434: Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.example.dtb] Error 1
> > > make[1]: *** Waiting for unfinished jobs....
> > > make: *** [Makefile:1508: dt_binding_check] Error 2
> >
> > I wonder if that is something that we could incorporate to our CI,
> > perhaps we can detect if the subject starts with dt-binding then we
> > attempt to make with DT_CHECKER_FLAGS, thoughts?
>
> What CI is that?

We have github actions that we run when a new patch appears on patchwork e.g:

https://patchwork.kernel.org/project/bluetooth/patch/20230124174714.2775680-3-neeraj.sanjaykale@nxp.com/

> Better to look at the diffstat of the patch than subject. Lots of
> subjects are wrong and I suspect there would be a fairly high
> correlation of wrong subjects to schema errors.

For now I'd keep it simple since otherwise we would have to probably
attempt to apply and make with DT_CHECKER_FLAGS every patch, well
perhaps that is ok if that doesn't produce too many false positives,
otherwise we have to filter the output like we do with the likes of
smatch and building with make W=1 C=1.

> Rob



-- 
Luiz Augusto von Dentz
