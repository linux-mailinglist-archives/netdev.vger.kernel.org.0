Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A806EE5DB
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 18:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbjDYQer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 12:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbjDYQeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 12:34:46 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1E3CC17
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 09:34:44 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f1e2555b5aso21022175e9.0
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 09:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tarent.de; s=google; t=1682440482; x=1685032482;
        h=content-transfer-encoding:mime-version:content-language:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/PqzrQZICxoGVuff1ftDQ9jlsT2Tw20DFw6cNzVDyW4=;
        b=cE8pSkRLPmTWlPX9xZwWA+Cmoqeh+je3Mt57XNah48gy4jRgYR5v0ikONJ91yPfiDY
         J8GXvlrsQTplwgEQnLnUW9K7Sa7SOmA/eq+g6tFOMQJG7AiNWA+3RsKztqHaWxesYTCY
         l7ZdcgbG6q7ej3N3FUlmKz4N0mVj6VI21oAHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682440482; x=1685032482;
        h=content-transfer-encoding:mime-version:content-language:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/PqzrQZICxoGVuff1ftDQ9jlsT2Tw20DFw6cNzVDyW4=;
        b=HCCr2rfkI4zZ4sHjivaXgasDsxkmkUFFLYq7bW2pABXrp7+rqI15bS6Xbk9lUlKZQl
         FQb3ygQoPo0uh5b9nJUVI7uzXJyWsM8v+bKC2UyOJ5WGoq9y7HnaYsv9DCcFHzj4zD/P
         gHt5TS5ABiGM85CQtzecjiH4e0WFKkfXyYGlXTIFEp2qhrnKim9fu8Jiy+eKGLN+fZX8
         pQymWVPfVDuIwGFnxK/sbuK6p1BWjl83G1quqxMRCUUvGcXOea2smZBTnt4jvLv64CVi
         NKUolwCXvm4+hbTnBTnOyhy7MlnMq+jv8gyZFsrdjVOZrxlx3Xiv+7fX5DiPayAuK36e
         62Yw==
X-Gm-Message-State: AAQBX9fKRVNY4smPBYmK5j33DAyxbJTTGccLFPu2p9KK1CAjSQCknR0J
        mDPk0xpxzD3oeewVZyPRs21Zq9RA3OlqQ4AofUxj+sd34beySdhwqnJyHT19GFsczLIt4+ce9+V
        TKOAG5/Jox+qWLoqT9z4Fu4DZ8/yXj9OKdS2AixvpR/lyO1oV8ZkxF1h9KIxrq+WY0gDQi7N8Lg
        ==
X-Google-Smtp-Source: AKy350YjLjEI5umztB7Uad3H4KjpsIAVSn4zeClM1gjBlFLqbfKjCkfv5FL8n29Bc74IqxdCNuwx8g==
X-Received: by 2002:a05:600c:2309:b0:3ed:f5b5:37fc with SMTP id 9-20020a05600c230900b003edf5b537fcmr10705424wmo.1.1682440482451;
        Tue, 25 Apr 2023 09:34:42 -0700 (PDT)
Received: from [2001:4dd7:e530:0:21f:3bff:fe0d:cbb1] (2001-4dd7-e530-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de. [2001:4dd7:e530:0:21f:3bff:fe0d:cbb1])
        by smtp.gmail.com with ESMTPSA id n12-20020a7bc5cc000000b003f17329f7f2sm15398864wmk.38.2023.04.25.09.34.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 09:34:42 -0700 (PDT)
Date:   Tue, 25 Apr 2023 18:34:41 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     netdev@vger.kernel.org
Subject: minimum use of tc filter
Message-ID: <377594eb-bdcf-3beb-f29c-aec5808eace5@tarent.de>
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

Hi,

as some might recall, I=E2=80=99ve written a qdisc=C2=B9 which sort of
simulates 5G L4S conditions for one UE, that is, all
traffic passing it is shaped, delayed and ECN-marked as
if it were one 5G connection to one user equipment. The
traffic shaping is controlled from user space using pre=E2=80=90
recorded (or generated) data rate patterns.

I would like to extend this to be able to simulate multiple
UEs, that is, simulate multiple 5G connections using separate
SIM cards and 5G modems, to (the same or different) base
stations. These are independent in theory, but I would like
to keep having a central framework for both reporting to and
getting rate adjustment and other configuration from user space
(because latency matters).

Therefore, I would like to make a variant of the qdisc that
has a fixed/configurable array of most of the existing qdisc=E2=80=99s
internal variables including FIFOs, which is not too difficult,
and use the tc filter command to split traffic into them.

Note that this is different from having child qdiscs attach to
classes. This is a n=C5=8Dn-hierarchical model with a fixed amount of
subclasses (should probably be a tc qdisc add option and malloc)
where all enqueueing/dequeueing/etc. is done within one and only
one qdisc.

I *think* this should be possible. The sch_prio qdisc already
creates its classes, which don=E2=80=99t need to be configured. Ideally,
I wouldn=E2=80=99t even need classes, just ask the filters on enqueue
to which minor to route the packet, then do the rest myself.

But, as usual, I=E2=80=99m running into the utter, absolute lack of
documentation. I *think* that Qdisc_class_ops are needed, but
which part of them? There is no documentation for the struct
members, and sch_api.c is also very *ahem* sparsely commented.

So my questions are:

=E2=80=A2 is what I want to do possible at all? straightforward or with
  some amount of tricking the system (e.g. if the kernel creates
  sub-pfifo_fast, just ignore them and never enqueue into them)?

=E2=80=A2 what things do I need to add to a qdisc so tc filter can be used
  on it, how do I invoke that and obtain the result?

=E2=80=A2 what other expectations do I need to take care of (like that
  =E2=80=9Cq->q.qlen must be valid=E2=80=9D thing)?

=E2=80=A2 is anyone possibly interested in =E2=80=9Chand-holding=E2=80=9D m=
e through this?

Thanks in advance,
//mirabilos

=E2=91=A0 https://github.com/tarent/sch_jens/blob/master/janz/sch_janz.c
  now with documentation including a railroad diagram:
  https://github.com/tarent/sch_jens/blob/master/janz/qdisc.md
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
