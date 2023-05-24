Return-Path: <netdev+bounces-5134-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5D9470FC1E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:02:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8069C280F5D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA97319E68;
	Wed, 24 May 2023 17:02:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED991951A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:02:49 +0000 (UTC)
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEFDBB;
	Wed, 24 May 2023 10:02:48 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-75b0df7b225so92906085a.1;
        Wed, 24 May 2023 10:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684947768; x=1687539768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c52Wx5gVDucU8yW4B1ni7YIFK5C1wFPEKZmBqYnCprk=;
        b=D56ZvRFwklB5J3kFeIVqKOeeLB0IQH7EItC8K4tS4thFpG5MqlWh9+yo4GCNvjEoa9
         TFyvLLitG7b27mz0/nitnSnD81oeGspf0vhmtkMY0bhZDUPOQd0YF8c+z6TN10mpakRD
         DK73pL+IotjPWSEjYty+6yfrQsuUDSpwL3HO1MD+z9fMZANo9vl83W32Qar2VRFMIGDk
         u072R/HZeNWeC4S9BwzpL3mKUB1IJFOqApANvCvV3i7H5+aBF2GwoZfIMJ4+2eecqeQO
         chfjvGN5dqb11k0khY2jf/eRj3hGnZHJzYxers5Qxnvw515Gz7VzNH1jYI9qqLYipO5y
         opfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684947768; x=1687539768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c52Wx5gVDucU8yW4B1ni7YIFK5C1wFPEKZmBqYnCprk=;
        b=baD5SrRU8diEZgzfDbAxSeMUIJCWBntCANWu9wmlAutDsnzsFMcMYfd7KJv6NUlApQ
         hWGNfa5odwrYoAbRxG1Metb74dkwSVjjxRL0ROPYdyGUay41i41bj76szz5yW6B1KXfV
         dB3HqQiLoBHnV7qDfzLFxdVWpCc1RBAC3tTrbdn/Ipd63TU8rHzzTMZeJczDMfvmXYLp
         XV8/OmE6/1xI/xBkpEgy1Wbdf9wW10xPyA+7K5pUm90322tBwbqF5vEHjxuIvSP7eSom
         Tyk3zOE6l/3sElb8DTPCIxDijT/M/km7ReCHJkzirp+vuk99TAPzot8xWS9DsXi3Ezzp
         dqAA==
X-Gm-Message-State: AC+VfDwykreadVvBXwhSO7JcsoSqVBTxQrCZaw+F7SKU/tnX4ghoom1p
	aMJYXbl/HwZdUhe208KEYMG/TYp1Liql5gHwXywTKgAr
X-Google-Smtp-Source: ACHHUZ5XBYR1T0PHseLO3zU05/JyEAe8A+LbxvBmC+7mcUaj56Af9QuajP3SmdP8Nx5M23t+mxKV7czbCI5U7nfZVfE=
X-Received: by 2002:a37:492:0:b0:75b:23a0:d9f4 with SMTP id
 140-20020a370492000000b0075b23a0d9f4mr8426925qke.74.1684947767725; Wed, 24
 May 2023 10:02:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230523223944.691076-1-Kenny.Ho@amd.com> <01936d68-85d3-4d20-9beb-27ff9f62d826@lunn.ch>
 <CAB9dFdt4-cBFhEqsTXk9suE+Bw-xcpM0n3Q6rFmBaa+8A5uMWQ@mail.gmail.com> <c0fda91b-1e98-420f-a18a-16bbed25e98d@lunn.ch>
In-Reply-To: <c0fda91b-1e98-420f-a18a-16bbed25e98d@lunn.ch>
From: Kenny Ho <y2kenny@gmail.com>
Date: Wed, 24 May 2023 13:02:36 -0400
Message-ID: <CAOWid-erNGD24Ouf4fAJJBqm69QVoHOpNt0E-G+Wt=nq1W4oBQ@mail.gmail.com>
Subject: Re: [PATCH] Remove hardcoded static string length
To: Andrew Lunn <andrew@lunn.ch>
Cc: Marc Dionne <marc.dionne@auristor.com>, Kenny Ho <Kenny.Ho@amd.com>, 
	David Howells <dhowells@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	linux-afs@lists.infradead.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 12:02=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote=
:
> So the compiler warning/error needs to be fixed a different want.

Understood.  Would caping the length at iov_len with a ternary be sufficien=
t?

Regards,
Kenny

