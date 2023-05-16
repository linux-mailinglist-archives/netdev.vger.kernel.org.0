Return-Path: <netdev+bounces-3120-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 613BB705899
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 981C0281341
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41A324EAF;
	Tue, 16 May 2023 20:20:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47AE1D2C6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:20:13 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079AD1AE
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:20:11 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f42769a0c1so101213655e9.2
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tarent.de; s=google; t=1684268409; x=1686860409;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vIKXHU8f4dI25XkIJ8Iqf/BJKEeVRhN6JrsFeo127dQ=;
        b=iGx13pIVNgv/3Mmx1Nk3ONQmKDjo7GKck5axK7FV0P43k0GEonqdEnUDzWaw/LKBAx
         zx/k5lCckpOQDaRh8jmRyCOpsS+8GCOaLnzD7nb78AQbGMmKXYZzs4mGv1O+XQx/z+Xe
         V3iNoV/F/+N/uOf0l2Mg9Er3WTMe+MiPd4GGk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684268409; x=1686860409;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vIKXHU8f4dI25XkIJ8Iqf/BJKEeVRhN6JrsFeo127dQ=;
        b=X/94qs26Dd3yf+E4AZxUW4wuoPvvZ38dQhr5+46zUqQeEFhs88rqNPG7uimjKdo4W6
         HzbD1lrNo7gVdhQchNYH+YxqzpM9nZsp8cAjzZ4mrkLIMtjkvXrb+VFMs3XYJ65W42Ir
         +2uiglUJYEFYxvLhL25QqwK8sseXJph5K66ipsV4T7KE/IVBEmrDivR+xZcYUs9mlBZP
         DbnUZ2J/r+DV9jPtlvVinWL1xU7m6A0QJ0BmayMbo8R1rijrpfjB2SIeAZotDKH9P7rW
         iVv1+LVT9ugr76yQ5lGX423FpskTqwR1jsan9J9QtEjEDISrN+gmOfiL+EAYEp4R3Ibv
         lyWA==
X-Gm-Message-State: AC+VfDyKz5tKjd/EjZnwvwxN+ddo6K5gfjuwdJ/IjUrQR4ST0UA4QVmX
	tGpWETP3I4NAVko7ie48wQ8dKZmwYbwi4/D3TEY=
X-Google-Smtp-Source: ACHHUZ7ceLAMaoKwwvns232nmzxjLucngcirisMHRTEStrmqtV2Wx9eeha6Pdu3P7FgaUnOQPEXk4w==
X-Received: by 2002:a1c:741a:0:b0:3f4:e7c2:607d with SMTP id p26-20020a1c741a000000b003f4e7c2607dmr14150716wmc.13.1684268409488;
        Tue, 16 May 2023 13:20:09 -0700 (PDT)
Received: from [2001:4dd7:624f:0:21f:3bff:fe0d:cbb1] (2001-4dd7-624f-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de. [2001:4dd7:624f:0:21f:3bff:fe0d:cbb1])
        by smtp.gmail.com with ESMTPSA id x7-20020a1c7c07000000b003f182a10106sm9938wmc.8.2023.05.16.13.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 13:20:08 -0700 (PDT)
Date: Tue, 16 May 2023 22:20:07 +0200 (CEST)
From: Thorsten Glaser <t.glaser@tarent.de>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
cc: Stephen Hemminger <stephen@networkplumber.org>, 
    Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
    Haye.Haehne@telekom.de
Subject: Re: knob to disable locally-originating qdisc optimisation?
In-Reply-To: <877ct8cc83.fsf@toke.dk>
Message-ID: <b88ee99e-92da-ac90-a726-a79db80f6b4@tarent.de>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de> <20230427132126.48b0ed6a@kernel.org> <20230427163715.285e709f@hermes.local> <998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de> <877ct8cc83.fsf@toke.dk>
Content-Language: de-DE-1901
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 16 May 2023, Toke H=C3=B8iland-J=C3=B8rgensen wrote:

>Pushing stuff into a
>qdisc so it can be ECN-marked is also nonsensical for locally generated
>traffic; you don't need the ECN roundtrip, you can just directly tell
>the local TCP sender to slow down (which is exactly what TSQ does).

Yes, but the point of this exercise is to develop algorithms which
react to ECN marking; in production, the RAN BTS will do the marking
so the sender will not be at the place where congestion happens, so
adding that kind of insight is not needed.

Some people have asked for the ability to make Linux behave as if
the sender was remote to ease the test setup (i.e. require one less
machine), nothing more.

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

