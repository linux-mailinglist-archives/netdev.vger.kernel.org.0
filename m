Return-Path: <netdev+bounces-5748-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE826712A1E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:00:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 212B12818AA
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4164727702;
	Fri, 26 May 2023 16:00:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35053742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:00:17 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C6EF7
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:00:15 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f600a6a890so75905e9.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685116814; x=1687708814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xkU55uqzq+ekvAZs1dNWqR5r1+9lSZcOTbRvaL+8zq8=;
        b=hBlcOZEbxJxr/uZ7ExB4Ijf6sDeFpdS+91daVKdRfd4tC2i6rfOq8hNIdhnbPMQjd/
         0hbo/3YPl4iZfgszqgewLAHSpVuHtNQOMV0qZHNRaH/ySrwBpfTjWRnOFkSPgY9Bnt/0
         7gZmY2g1tPX3jDxOONBzcJxlrMxrfJxDD/r0olxEQ6x1slRCycZebagXpIEQHkua9st1
         Izu0v0sRzIiWzO8tNHLWUVfajkF0eNXG/lpzXVvrDoEgicZC+/6AjK8/13Ad3TGw9MKA
         laWYCnOo+fBsQdcYzeKjPZgt+i4kwkS1oS3SiuMPfXqA8pwJAfB7fxVPwRk6lLrhjGIH
         ZpCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685116814; x=1687708814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xkU55uqzq+ekvAZs1dNWqR5r1+9lSZcOTbRvaL+8zq8=;
        b=REBy8HsU2wJ4VuIpcena9kqmbNTRq8PICgekXXLk/Rp/krLWvh7lL/lJzH8UfK1ZXQ
         g6WlPdf8wSfbLW+X0pLhQEW4xVDk/nu8lQeeHP952z9RIQ5mnpNb+JkFbbpeiMNXhe2G
         uiQmgUmtuMe3Ok8F/BP4BcLzYk/mloJ5IifMVr/9NAEksfwnRubpcrskYcbKeGuZaBIE
         MoIg9d5kbLbxO2uFVgV/jF6N3lYxbO/SXyUV1zkdgqLnvsaVhbXfZ1xAEoOkTI/puvD7
         X2C8HYJB89GZn3NBTojSh0QpYvDw3HHaXDJmMgjEyf24VzS5NXnOdEPU+6L2hh7z/Iub
         5uNw==
X-Gm-Message-State: AC+VfDxJxYboyob2Lv0bjYR0M+JK2g7twLN5MxQwDufYIqCvnZD1f3rt
	BinA7K+J+cX+OMGlvdkStGhp8wMCJnIT7/dsakrj6x1BlUzXAcPLGe4=
X-Google-Smtp-Source: ACHHUZ6XtQA8ACi3DtsPxc19flWObiDAt96Wd0LOg+dJc6I+OFPcxRFZEks8pe8qaFLfXVuDuxzzc3sw/eebnQLlKx8=
X-Received: by 2002:a05:600c:4f4a:b0:3f4:2736:b5eb with SMTP id
 m10-20020a05600c4f4a00b003f42736b5ebmr103572wmq.1.1685116813579; Fri, 26 May
 2023 09:00:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526150806.1457828-1-VEfanov@ispras.ru> <27614af23cd7ae4433b909194062c553a6ae16ac.camel@redhat.com>
 <027d28a0-b31b-ab42-9eb6-2826c04c9364@ispras.ru>
In-Reply-To: <027d28a0-b31b-ab42-9eb6-2826c04c9364@ispras.ru>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 26 May 2023 18:00:01 +0200
Message-ID: <CANn89iLGOVwW-KHBuJ94E+QoVARWw5EBKyfh0mPkOT+5ws31Fw@mail.gmail.com>
Subject: Re: [PATCH] udp6: Fix race condition in udp6_sendmsg & connect
To: =?UTF-8?B?0JXRhNCw0L3QvtCyINCS0LvQsNC00LjRgdC70LDQsiDQkNC70LXQutGB0LDQvdC00YDQvtCy0Lg=?=
	=?UTF-8?B?0Yc=?= <vefanov@ispras.ru>
Cc: Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 5:58=E2=80=AFPM =D0=95=D1=84=D0=B0=D0=BD=D0=BE=D0=
=B2 =D0=92=D0=BB=D0=B0=D0=B4=D0=B8=D1=81=D0=BB=D0=B0=D0=B2 =D0=90=D0=BB=D0=
=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE=D0=B2=D0=B8=D1=87
<vefanov@ispras.ru> wrote:
>
> Paolo,
>
>
> I don't think that we can just move sk_dst_set() call.
>
> I think we can destroy dst of sendmsg task in this case.
>

dst are RCU protected, it should be easy to make sure we respect all the ru=
les.

