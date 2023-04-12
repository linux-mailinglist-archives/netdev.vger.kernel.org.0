Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68B46DFF55
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 22:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjDLUBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 16:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjDLUA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 16:00:59 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B13BD3;
        Wed, 12 Apr 2023 13:00:58 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id y4so12979964ljq.9;
        Wed, 12 Apr 2023 13:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681329657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SV12FO2b4kT0IrF91lFzuk9597ZEnM0XOQm9xOUoWhg=;
        b=FRubNzWLXGSns4USosxtOjJbEEy9u6VqM7bheSYfY1uYTDl/z3pzUnp5POVdw9RZEx
         4walJXnsyPnuM90+x6cLapou86kSnjmEISEwn0I3gY/E2tIFGroZmABZyFGBBrPrIiNo
         kRDTxiAiPT3WjjGCNJfGeyYQv54zCNbQ6TiHYPz7jpWwd3gGTSDgT+xgLwIj3kjBUiMZ
         9j11giUY9AMUAdOMvQhvASKdIXHNlTNDMaZS/ssCzV0lmsuHXSGV7GsO0scWAPm0k8k0
         7NR+T/C4G8/0kNFecWmKs6Y2tGTU1x85VjkFjX6odHUqnvI+1xK1kHwE241khWR9nPrY
         9/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681329657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SV12FO2b4kT0IrF91lFzuk9597ZEnM0XOQm9xOUoWhg=;
        b=XwzKc0QmjEWncbQePp3QoeFG9TDGDir1zhJ+hR864vwXgkSi+3KAIVg3ytPDLKcdtY
         trcJYCKPNZa0/53RYXN73cfMFxSeyeVvQfSTPpwCyElsex/2WnlRms2i5GxKLXZKw+s5
         R7ai8LOHYWLO+Vx3/hibCkNSUqFN7SOmpRM/2U9bcsA+nLXERAgJA6RNMT61vIv7O3kn
         +wa+aVpLTeV3YnibII31ibmLhiKk2ZKQIC3SDYBiRC9WfeBeP6UI4rUiRhsXJRgphJh5
         1bpgi8+L7nXsqVUHiI2h5njC3vV3E0eRUfLeYB99j5URa2GQ5h2HCBs6xXGMVSJMun3B
         eFjQ==
X-Gm-Message-State: AAQBX9ccMAwG1TH9o6bBSbed1lHmfSPR78joe9pRPs7M4o70vGj/UI4D
        qwgfxF/1G1L15kxc+jaGddtbPY9YW9TCE2qF7lo=
X-Google-Smtp-Source: AKy350bucxC4IK3WvOK+UzT+bI0MfALmLc9++97Iaj6iW3vVQ/fWqaczVGW32KFQ6Z3ddGlZeNanoOPtEbfHxF7YEew=
X-Received: by 2002:a2e:9c9a:0:b0:298:6ffd:e856 with SMTP id
 x26-20020a2e9c9a000000b002986ffde856mr1116156lji.8.1681329656693; Wed, 12 Apr
 2023 13:00:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230326233812.28058-1-steev@kali.org> <20230326233812.28058-3-steev@kali.org>
 <ZCVgMuSdyMQhf/Ko@hovoldconsulting.com> <CAKXuJqjJjd6SY1g3JW8w53rEVCqgDkJXQ=1iA3qXcF+C9qv1SQ@mail.gmail.com>
In-Reply-To: <CAKXuJqjJjd6SY1g3JW8w53rEVCqgDkJXQ=1iA3qXcF+C9qv1SQ@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 12 Apr 2023 13:00:44 -0700
Message-ID: <CABBYNZKX9bixyy8GZ0VDFaeNeY0_MSVDDNvcTqiAXEx8zFXfbA@mail.gmail.com>
Subject: Re: [PATCH v8 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
To:     Steev Klimaszewski <steev@kali.org>
Cc:     Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steev,

On Thu, Mar 30, 2023 at 9:35=E2=80=AFAM Steev Klimaszewski <steev@kali.org>=
 wrote:
>
> Hi Johan,
>
> On Thu, Mar 30, 2023 at 5:10=E2=80=AFAM Johan Hovold <johan@kernel.org> w=
rote:
> >
> > On Sun, Mar 26, 2023 at 06:38:10PM -0500, Steev Klimaszewski wrote:
> > > Add regulators, GPIOs and changes required to power on/off wcn6855.
> > > Add support for firmware download for wcn6855 which is in the
> > > linux-firmware repository as hpbtfw21.tlv and hpnv21.bin.
> > >
> > > Based on the assumption that this is similar to the wcn6750
> > >
> > > Tested-on: BTFW.HSP.2.1.0-00538-VER_PATCHZ-1
> > >
> > > Signed-off-by: Steev Klimaszewski <steev@kali.org>
> > > Reviewed-by: Bjorn Andersson <andersson@kernel.org>
> > > Tested-by: Bjorn Andersson <andersson@kernel.org>
> > > ---
> > > Changes since v7:
> > >  * None
> >
> > Only noticed now when Luiz applied the patches, but why did you drop my
> > reviewed-by and tested-by tags from this patch when submitting v8?
> >
> > For the record:
> >
> > Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
> > Tested-by: Johan Hovold <johan+linaro@kernel.org>
> >
> Oops, that wasn't intentional! I only meant to drop it on the dts bits
> as that part I wanted to make sure I got right based on your comments,
> my apologies!
> --steev

This one seems to be causing a new warning:

drivers/bluetooth/hci_qca.c:18
94:37: warning: unused variable 'qca_soc_data_wcn6855' [-Wunused-const-vari=
able]

--=20
Luiz Augusto von Dentz
