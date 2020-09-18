Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9692703BE
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgIRSJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgIRSJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:09:02 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3B7C0613CE;
        Fri, 18 Sep 2020 11:09:01 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z1so6531529wrt.3;
        Fri, 18 Sep 2020 11:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=V7TYn/alxMmRQm9PDXJHaR4ciP91a3Wj/zuAejX1JHE=;
        b=lW1Ctf+6Zej2YzB4z4tRElKnEwvo5EJamrq3WGSeVLT6ftRjxdKk1Zrmy6wY/fOyUy
         wVEUb7eRA6dSNDxbSkEzuc/QhA1T/zI9tyelDqluu+4/ITx9gRsMtDDpxjBROJyy2ka8
         pccjObn1Q9H1MBCQmiG0AnvhV3IM1SSwGO922KkdWRL06FkfWGc9aejb+0mfGxJVpaq2
         fPHoEvpdazaPD/cFWojd+eIIUsw9n9MQWuW8vJn+0JxisWJwz6Vwoi2tD+mQbWCERgAn
         oOauTZEkZafbPmy4ml2QhNglV7Xm+Pvs0aUOnNpqvf3v5rSk5f0nxNWnkjGAI0j/tMP5
         EhuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=V7TYn/alxMmRQm9PDXJHaR4ciP91a3Wj/zuAejX1JHE=;
        b=A7HpRGQRPwHSh2NzOtONRjddVs3rkWUUh/f3gBlSCs36Wp5fhYmFVdLTcFzFu/zRZ8
         yJcHq3n/1xs6czpmEisbTe/A09asbUhlWEWBOpZgNJis2OAO8s3uG6+Ov2iIFgsn9mcP
         PPnaMzVN5kvxsGwmZPQZcirM8q4+2eSqc7DxLo7Z0vZNW3DW9ugu/AzfF1kyqEH99T4R
         +J0G6qZ4LwyGZ/NuUVlM0YegJKe44HHqzTFqlVIPRYIVzVVLAMa1tM7Xfj7cuc+KEEsc
         UPTba8zxkKPp/Vzxm8pSEWRDyHZMRFLHgu01zAN87MhIAv9ZVs3bKocJvLRQR85rvJRw
         znBQ==
X-Gm-Message-State: AOAM531/IPU1zyuJz8PXTQh0zofTIcXaBTieoCQ9gN3dtLFTNN595LSW
        nWf3tbuGlrRSkS+h+ZinJIM=
X-Google-Smtp-Source: ABdhPJz6xIijTdoGDOaGOtsRHj23XUIM8Dl2BFmzbpi6A43qDBLuSRluS8Vjuej5WASj7gRAQ+sSnA==
X-Received: by 2002:a05:6000:1184:: with SMTP id g4mr38640530wrx.20.1600452540424;
        Fri, 18 Sep 2020 11:09:00 -0700 (PDT)
Received: from AnsuelXPS (host-95-248-206-89.retail.telecomitalia.it. [95.248.206.89])
        by smtp.gmail.com with ESMTPSA id c14sm6380766wrv.12.2020.09.18.11.08.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 11:08:58 -0700 (PDT)
From:   <ansuelsmth@gmail.com>
To:     "'Christian Lamparter'" <chunkeey@gmail.com>,
        "'Kalle Valo'" <kvalo@codeaurora.org>
Cc:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ath10k@lists.infradead.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        <linux-mtd@lists.infradead.org>,
        "'Srinivas Kandagatla'" <srinivas.kandagatla@linaro.org>,
        "'Bartosz Golaszewski'" <bgolaszewski@baylibre.com>
References: <20200918162928.14335-1-ansuelsmth@gmail.com> <20200918162928.14335-2-ansuelsmth@gmail.com> <8f886e3d-e2ee-cbf8-a676-28ebed4977aa@gmail.com>
In-Reply-To: <8f886e3d-e2ee-cbf8-a676-28ebed4977aa@gmail.com>
Subject: R: [PATCH 2/2] dt: bindings: ath10k: Document qcom, ath10k-pre-calibration-data-mtd
Date:   Fri, 18 Sep 2020 20:08:55 +0200
Message-ID: <018e01d68de6$c72edce0$558c96a0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJEWVdigiv7VEZfce04PgG7d9c+lQHuGaaaAYeoZCCod2yTQA==
Content-Language: it
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Messaggio originale-----
> Da: Christian Lamparter <chunkeey@gmail.com>
> Inviato: venerd=C3=AC 18 settembre 2020 18:54
> A: Ansuel Smith <ansuelsmth@gmail.com>; Kalle Valo
> <kvalo@codeaurora.org>
> Cc: devicetree@vger.kernel.org; netdev@vger.kernel.org; linux-
> wireless@vger.kernel.org; linux-kernel@vger.kernel.org;
> ath10k@lists.infradead.org; David S. Miller <davem@davemloft.net>; Rob
> Herring <robh+dt@kernel.org>; Jakub Kicinski <kuba@kernel.org>; linux-
> mtd@lists.infradead.org; Srinivas Kandagatla
> <srinivas.kandagatla@linaro.org>; Bartosz Golaszewski
> <bgolaszewski@baylibre.com>
> Oggetto: Re: [PATCH 2/2] dt: bindings: ath10k: Document qcom, ath10k-
> pre-calibration-data-mtd
>=20
> On 2020-09-18 18:29, Ansuel Smith wrote:
> > Document use of qcom,ath10k-pre-calibration-data-mtd bindings used =
to
> > define from where the driver will load the pre-cal data in the =
defined
> > mtd partition.
> >
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
>=20
> Q: Doesn't mtd now come with nvmem support from the get go? So
> the MAC-Addresses and pre-caldata could be specified as a
> nvmem-node in the devicetree? I remember seeing that this was
> worked on or was this mtd->nvmem dropped?
>=20
> Cheers,
> Christian

Can you give me some example where this is used? I can't find any =
reference.

