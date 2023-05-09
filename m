Return-Path: <netdev+bounces-1039-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1EF66FBF08
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65A42281242
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 06:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B24C53AD;
	Tue,  9 May 2023 06:09:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789AF20EF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:09:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8DE83E5
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 23:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683612560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xYhEw58QOtrTR8CqVvluhfLaHvAq1hUARL3MMuN94lI=;
	b=Je0Hy7cot586sM9gdCl530CnxQ75jk9wLdU3CLbgKobVJLRnxwpiFwZMKrd5dvt4idP+BO
	4z7zcS/YtC1ekLJhXK73xBb1FwzHE0gKmC25DxC6QxTKV7ZxPdh2eNTDE8UBX5+QKvtEzA
	0oxtIyvq7d3UFLLl1Myx8uS3qIHcZw8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-p8Cfst4HOlOSrX3cQ7lYcA-1; Tue, 09 May 2023 02:09:19 -0400
X-MC-Unique: p8Cfst4HOlOSrX3cQ7lYcA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-50d8bf85462so3844887a12.2
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 23:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683612558; x=1686204558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xYhEw58QOtrTR8CqVvluhfLaHvAq1hUARL3MMuN94lI=;
        b=MP1X8z4NRBU8V3Z5ppSOVaBGqmKEcz9H4pjmWlNe84g19acm7980T5KVTTNd78mUqq
         8tbKHWm+pfvS6lue2vhWy88zha/lK65yTj+xvwC4S9+/Avcq6GVCQi2rrLHqVkLzg9W/
         qC7nxkEvy9/E4J4EJsAjVVmn3uCGmSB0cnuwQ7YEkp49T7RdVWzPibGibxLqqMZD/TfC
         vrHufJF/uBNCd6JMU52hAR1HmWZbNfOwHqLxi1CeMGIZvrKUpovQGp2zqEZzrE8vlGbL
         duhTCcw89HdUmYyCAdQ9KuelWDvIpyS/Fri7KaYxYkuOGYMdOMAbPRw1zb/JXulfbOSs
         uqgA==
X-Gm-Message-State: AC+VfDx9dvJJPQ79TOwN0tBSQNHTVKgEfErcLp02Td7jeajU3EuoLkNp
	yz5V2W8zx3SGSTEm68F8TkgcSDlCJ/EjYyi1Dk68irRpQStLUaCn9e5F4IkbPLiLDAx5iBNaYgo
	AchbpUchVtRKqSWA9/ejb4IehyTUMrq71
X-Received: by 2002:a17:907:982:b0:965:7fba:6bcf with SMTP id bf2-20020a170907098200b009657fba6bcfmr9890235ejc.67.1683612558550;
        Mon, 08 May 2023 23:09:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4UpNrXtSZCJIQsY+5vPCnqlsHe3pUksDMu5No+uTVfnG8P3C3SDb36j31EueU84Nmn6mes94+2YvaSqq56Y+0=
X-Received: by 2002:a17:907:982:b0:965:7fba:6bcf with SMTP id
 bf2-20020a170907098200b009657fba6bcfmr9890216ejc.67.1683612558277; Mon, 08
 May 2023 23:09:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508092327.2619196f@kernel.org>
In-Reply-To: <20230508092327.2619196f@kernel.org>
From: Michal Schmidt <mschmidt@redhat.com>
Date: Tue, 9 May 2023 08:09:07 +0200
Message-ID: <CADEbmW24+sbX3AzGuDnSboZ-Q-y3PkPGRx7j1-xm7Zf_TsSGmQ@mail.gmail.com>
Subject: Re: [ANN] net-next is OPEN
To: Jakub Kicinski <kuba@kernel.org>, David Miller <davem@davemloft.net>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 8, 2023 at 6:23=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
> net-next is now open for patches!

Hi!
http://vger.kernel.org/~davem/net-next.html still says it's closed.
Is David the only netdev maintainer who can update the page? Could it
be made writable by Jakub and Paolo too?
Thanks!
Michal


