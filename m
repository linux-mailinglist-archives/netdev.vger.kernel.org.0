Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8803F6EE5E4
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 18:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbjDYQjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 12:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbjDYQjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 12:39:05 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F165D32E
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 09:39:04 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-2fe3fb8e25fso3679130f8f.0
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 09:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tarent.de; s=google; t=1682440743; x=1685032743;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ZVxlMPHMj6WwUzQGsJkP2KWDpbVmMry6mFaZ7KSeAg=;
        b=oZkRSFRGyCh9RoRdQEmCfNl4YZ2xJIEHAX0WUYFozCt8mxiKYHIvyEW3q/5mdDFiGO
         U3IkCsx4alOIIDXaEc/TdrP7IZuWm1b7fi0sxBYNzcyOu4uiY3pEo/zvNjlDFiW90vNm
         Cdl8siy6hU++DuJtVtyZAntX+Y5blx3EtmZuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682440743; x=1685032743;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3ZVxlMPHMj6WwUzQGsJkP2KWDpbVmMry6mFaZ7KSeAg=;
        b=fJYG83J+EcXR5dVDroYvNlA0iGLjXlY5Rv/GkjBU3feaCfzS/FLbnKg+cIulBOSYaR
         nlJ9FHva3QYU8qGRsiO3ApBG2mUvG/HcecwyV0kOuc3m0LctF1w33KGgti6AC/UthLam
         8ZidtA9e5X12QatWMtes6xi7aeit66DVRNnylkFbz+d2QcMgPF4rVPzvwBSfOjeObKCq
         fwkBVGB7dicbKI+nEzOt6P09xmPB8csC+/uh4IBiCZ1pSKV11C1n5CH1U59dDle1BpFf
         FCCm5+jDlkERDrjuExVg57kKmTKTebyldQbWjPRL2/HQMN4K0tfOOpFc4SqjleuRrgb8
         TmNQ==
X-Gm-Message-State: AAQBX9dUvHvJVXL1hSBZ320MShk7NcoX77YKvL+uV/x2tUtL+8tkh3sW
        GoY6qcJffx5Y/mzzJ6zc6CoKI2lVxvGr9IL3Wfgk/5O8xX/0+w3/aLM3hcVfiNSY/Pgbu3EhONH
        wceR/5bmjZPrGBDLOIr6yfGoOMHYCO7qYPjw+9W1JSqxebFOd5QWoi3hUEt/34w6xGRmeY9CrEy
        UN
X-Google-Smtp-Source: AKy350bZrzgOl6tf8XQnIKD1AoZYFaXqb/ToUucgiEGMyHncllYaVVog5XjZljBDH/sSTsQHNf6MOw==
X-Received: by 2002:a5d:4801:0:b0:2f8:e190:e719 with SMTP id l1-20020a5d4801000000b002f8e190e719mr12560183wrq.65.1682440742953;
        Tue, 25 Apr 2023 09:39:02 -0700 (PDT)
Received: from [2001:4dd7:e530:0:21f:3bff:fe0d:cbb1] (2001-4dd7-e530-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de. [2001:4dd7:e530:0:21f:3bff:fe0d:cbb1])
        by smtp.gmail.com with ESMTPSA id d13-20020adfe88d000000b002e55cc69169sm13469935wrm.38.2023.04.25.09.39.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 09:39:02 -0700 (PDT)
Date:   Tue, 25 Apr 2023 18:39:02 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: Re: minimum use of tc filter
In-Reply-To: <377594eb-bdcf-3beb-f29c-aec5808eace5@tarent.de>
Message-ID: <58de3a16-ad75-19f-11af-65913d1177f@tarent.de>
References: <377594eb-bdcf-3beb-f29c-aec5808eace5@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dixi quod=E2=80=A6

>Therefore, I would like to make a variant of the qdisc that
>has a fixed/configurable array of most of the existing qdisc=E2=80=99s
>internal variables including FIFOs, which is not too difficult,
>and use the tc filter command to split traffic into them.

>=E2=80=A2 is what I want to do possible at all? straightforward or with

Alternatively, if another way to achieve a setup that roughly
says =E2=80=9Call packets going to IP 1.2.3.4 into handle 1:2, all to
IP 1.2.3.5 and fec0::2 into handle 1:3, all packets going to
IP 1.2.3.6 into handle 1:4, everything else into handle 1:1=E2=80=9D
and obtaining that in enqueue exists, for example via nft and
passing that information in the skb, I=E2=80=99m all ear as well.

bye,
//mirabilos
--=20
Infrastrukturexperte =E2=80=A2 tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn =E2=80=A2 http://www.tarent.de/
Telephon +49 228 54881-393 =E2=80=A2 Fax: +49 228 54881-235
HRB AG Bonn 5168 =E2=80=A2 USt-ID (VAT): DE122264941
Gesch=C3=A4ftsf=C3=BChrer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Ale=
xander Steeg

                        ***************************************************=
*
/=E2=81=80\ The UTF-8 Ribbon
=E2=95=B2=C2=A0=E2=95=B1 Campaign against      Mit dem tarent-Newsletter ni=
chts mehr verpassen:
=C2=A0=E2=95=B3=C2=A0 HTML eMail! Also,     https://www.tarent.de/newslette=
r
=E2=95=B1=C2=A0=E2=95=B2 header encryption!
                        ***************************************************=
*
