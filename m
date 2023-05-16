Return-Path: <netdev+bounces-3136-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21256705B71
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:41:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E0BA2811E5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 23:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A948910795;
	Tue, 16 May 2023 23:41:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6FD29119
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 23:41:27 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9C65253
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:41:25 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f475366522so818495e9.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tarent.de; s=google; t=1684280484; x=1686872484;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C65sXfL1mJr0UGlCqgcLGnQB6SsGV00QTiYnvn4B7qY=;
        b=hORYyhWRyRe9Gpy38UIsNeuopunUofSdK5/4Rx/Q5YnVlrjEZ5ejJtmnq9jCPi95S+
         n75thp7TfW14TO3IcJH9iSwWGuQkCgGInBl/tsZcWOPzXd1n/IUIZWsWNstLoYxA0d21
         t55VtXp+hCxZwBu0Q7GdFPYbHflPhM8dLy9Iw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684280484; x=1686872484;
        h=content-transfer-encoding:mime-version:content-language:references
         :message-id:in-reply-to:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C65sXfL1mJr0UGlCqgcLGnQB6SsGV00QTiYnvn4B7qY=;
        b=QQ2MXBqfn6cRvg2zxxEJxg3JDDQSjO/canWltTubNcL4TbtN4j1fsfhmlCWXCS5Clq
         nP4oq290xu/apq0ZrvdoHDgNS7krDb1n130fc45uhXKSeEQEtX3ZWvWF7RZiWgIXdrvL
         /rN0GQ369JcNMi4+tO3aRrou9cfxp9rSMqIoCWhxRHf7paCDr/SI7W/okjFzoSc4uMQI
         hAxoyfY3uGrktziYtIfCY+vYa49Esf/4CCmn0FBRavAnehB90b4C7CVtoZ46aF0w9LgX
         JqyGlQ/JG8mAveOY3V7CqmbVzGu/tHLmOEJNMvjcSBLkNmE9PlQ9aeVF6yly0zSR5EYY
         vGjQ==
X-Gm-Message-State: AC+VfDz9ESTIoiYigcSUZYUrK6Gu29scq8ryo2m+G8BqxzpdSafDZv8P
	3HBJj9Be6xkRDqoUPFmLVcoZH94487AaaTcPvLw=
X-Google-Smtp-Source: ACHHUZ6F6pUYiU9E+9h6eZsjdQGgQ6YF7saUl9vlD63f7rjgCD7PA4DJ9LShg6UWzTCNJRhb5ffntg==
X-Received: by 2002:a5d:43c4:0:b0:2f0:2dfe:e903 with SMTP id v4-20020a5d43c4000000b002f02dfee903mr29987449wrr.69.1684280484146;
        Tue, 16 May 2023 16:41:24 -0700 (PDT)
Received: from [2001:4dd7:624f:0:21f:3bff:fe0d:cbb1] (2001-4dd7-624f-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de. [2001:4dd7:624f:0:21f:3bff:fe0d:cbb1])
        by smtp.gmail.com with ESMTPSA id o14-20020a5d58ce000000b0030629536e64sm788703wrf.30.2023.05.16.16.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 16:41:23 -0700 (PDT)
Date: Wed, 17 May 2023 01:41:23 +0200 (CEST)
From: Thorsten Glaser <t.glaser@tarent.de>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
cc: Stephen Hemminger <stephen@networkplumber.org>, 
    Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
    Haye.Haehne@telekom.de
Subject: Re: knob to disable locally-originating qdisc optimisation?
In-Reply-To: <87y1loapvt.fsf@toke.dk>
Message-ID: <92a90-421-da6-f85d-133727f3730@tarent.de>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de> <20230427132126.48b0ed6a@kernel.org> <20230427163715.285e709f@hermes.local> <998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de> <877ct8cc83.fsf@toke.dk> <b88ee99e-92da-ac90-a726-a79db80f6b4@tarent.de>
 <87y1loapvt.fsf@toke.dk>
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

On Wed, 17 May 2023, Toke H=C3=B8iland-J=C3=B8rgensen wrote:

>Well, if it's a custom qdisc you could just call skb_orphan() on the
>skbs when enqueueing them?

What does that even do? (Yes, I found the comment in skbuff.h that
passes for documentation. It isn=E2=80=99t comprehensible to an aspiring
qdisc writer though.)

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

