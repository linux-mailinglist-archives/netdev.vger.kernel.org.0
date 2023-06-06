Return-Path: <netdev+bounces-8444-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75141724140
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:43:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E12411C20ECF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C017B15AFE;
	Tue,  6 Jun 2023 11:43:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47F315AD2
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:43:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E97F10D9
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686051798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0iOkAk95XE8FQwpIhnDE1IKjJKk6zhtO1ZOnSmwwQSI=;
	b=PJrVf1sI8+0PXEVw8bdqbq4eoJ6s2K3v5C19czWzrKlnTjVgk5LXV2rq43t9/lqE8/a8gk
	yVhFiR+d2NpgsDzqaStxUJAgVgTM2HYf2TnY9Cq8CSvZOI42etFmBUApSNqdb14TlBjk3/
	xknfO+kMw0aC5/rX59kTTFqEN9x5ZEw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-Bc012nv-NeqiiCkWIuJD8A-1; Tue, 06 Jun 2023 07:43:17 -0400
X-MC-Unique: Bc012nv-NeqiiCkWIuJD8A-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-626204b0663so10975136d6.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 04:43:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686051797; x=1688643797;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0iOkAk95XE8FQwpIhnDE1IKjJKk6zhtO1ZOnSmwwQSI=;
        b=Oc76q3SQV41KC/AgauTJgEjta3C0oyWwUzavuaDMJWiJO6ZNQGPEH0Zji8rf0dWJBU
         vvd5Dq8b+2/7NPGaQqQL8Nj4Ztvyeoe5BXu9bxx6N5eU6dzwgLUO7jJQwf0mBL/5Cs6g
         8lh6MGKsnUfYyTf6fzlXPRlbScuL24O4w6rUMk/Wcf5J//y1GJbdWWMFdIXL0KpdFSKy
         pJCs0zNAtDaf/DRJ8yOWmE0Of9p//GH32L3P4xbxgXe6xdK4zhqN/n3dygBxwBZEm1hx
         pRpzQ3S8UHjGGS92kMH7RxYBpOh7pOxM+hGHqI/n4IJY6WfUpqij45mDKoeSpAa7GrVC
         XxVA==
X-Gm-Message-State: AC+VfDzzyiUs5lUxN9k1U0MLiX5eoq3XaGCjQjshz6mGm5Jc2Sj+gzer
	xNTd0gZ14YrdqxxDe1dTu0J+x5+rODOR8nAcQVk3BCZBguVDc7YgE/MfZb76AdBkCjmobo+TszB
	HETXmxZdlpPAzZe7y
X-Received: by 2002:ad4:5ba3:0:b0:61b:73b2:85ca with SMTP id 3-20020ad45ba3000000b0061b73b285camr1881468qvq.5.1686051796874;
        Tue, 06 Jun 2023 04:43:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ61p1vk3RjEBKS2PqfFs3Br6L/1FIQ6CTrfW33hVbFPA/Ryxr+gq3ovb1lFdTIclm2YApTUtw==
X-Received: by 2002:ad4:5ba3:0:b0:61b:73b2:85ca with SMTP id 3-20020ad45ba3000000b0061b73b285camr1881461qvq.5.1686051796640;
        Tue, 06 Jun 2023 04:43:16 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-89.dyn.eolo.it. [146.241.114.89])
        by smtp.gmail.com with ESMTPSA id j6-20020a056214032600b00626137a0b95sm5292387qvu.96.2023.06.06.04.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 04:43:16 -0700 (PDT)
Message-ID: <21755d7f0d8bb51f748e65dde09986665c439341.camel@redhat.com>
Subject: Re: [ovs-dev] [PATCH net] net: openvswitch: fix upcall counter
 access before allocation
From: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>, Eelco Chaudron <echaudro@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>, dev@openvswitch.org, 
 netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
 davem@davemloft.net
Date: Tue, 06 Jun 2023 13:43:13 +0200
In-Reply-To: <ZH3zUdkxvxgaYjxf@kernel.org>
References: <168595558535.1618839.4634246126873842766.stgit@ebuild>
	 <ZH3X/lLNwfAIZfdq@corigine.com>
	 <FD16AC44-E1DA-4E6A-AE3E-905D55AB1A7D@redhat.com>
	 <ZH3eCENbZeSJ3MZS@corigine.com>
	 <69E863E6-89C0-4AC7-85F1-022451CAD41A@redhat.com>
	 <ZH3zUdkxvxgaYjxf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-06-05 at 16:38 +0200, Simon Horman wrote:
> On Mon, Jun 05, 2023 at 03:53:59PM +0200, Eelco Chaudron wrote:
> > > Yeah, I see that. And I might have done the same thing.
> > > But, OTOH, this change is making the error path more complex
> > > (or at least more prone to error).
> > >=20
> > > In any case, the fix looks good.
> >=20
> > Thanks, just to clarify if we get no further feedback on this
> > patch, do you prefer a v2 with the error path changes?
>=20
> Thanks Eelco,
>=20
> Yes, that is my preference.

I concur with Simon: Eelco, please post a v2 including the error path
changes.

Thanks!

Paolo


