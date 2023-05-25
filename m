Return-Path: <netdev+bounces-5282-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A377108CA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:25:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F35C6281502
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C06DDF40;
	Thu, 25 May 2023 09:25:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F215D53E
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:25:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0B2195
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 02:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685006735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TswzAacTiRxyVP+Y7gLK2/PWJAMEsT26lk8noEPtki0=;
	b=dBtnALWwojnhjdPVGHbTZqCPGiSrBtzKjRSRhHgHvGQSo7FavG3s/sULSF/7JuaUnF2h2i
	W7rAAF2V6yp5Ocl8pVA30t3Xx+OFUrGqoRGuG2mWgHMzN8IsUdIweJiQQ1n9imw8j+ye6S
	Ze8XkfTswoIKSjDfcts8kW9i3PN3Obc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-_JBUa85XP-i1fes6s5yxFQ-1; Thu, 25 May 2023 05:25:34 -0400
X-MC-Unique: _JBUa85XP-i1fes6s5yxFQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3f7d72d552fso1705901cf.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 02:25:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685006734; x=1687598734;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TswzAacTiRxyVP+Y7gLK2/PWJAMEsT26lk8noEPtki0=;
        b=TIlGDhwduKbofCoywyGml7aNhjgwVWQ2W4tK221uNY2ipCWs0ZHHjGQNQ5YnTGa1av
         9AgOkV8M5vAhbqjblp2Gmn0fiOo/5pcRcJZx6hIqH6qO5Vq73qgIoHJPJ5Pl3LNmTfUO
         D7CbURcc7c7QhCB3dDND0xLEUnQSJVWEeDLnA7PHsq/F/5RDCWzch2rJky/59oqTOQ4S
         RKGohoYz1+iBkYPmXnavlHDWfqN2Yzu1mgZuwbOPq/lV+PAxJDTHVTtDdOXWFtHvMeiK
         5Ohetm87I7KruT2XSYtgVjWKRrCJiS+RKn1fxgSjGoZ4fZ3gt/bJxmmc3VOTbw41Uzbx
         TGBQ==
X-Gm-Message-State: AC+VfDzliDhTHaN2VnkrCwntF5Dl4zU32SEFjlHgw1uDT6hm8HMmzKW4
	hcGgneIg8m8xxk6vPqsHe7A9RHz8hrIdrIubW5xDsSQnNrQrTbCkqvseK2EKUFtWTmnfgUKwA3d
	eKDZHzCp5C9n5A/R2
X-Received: by 2002:a05:622a:1802:b0:3e3:c889:ecf9 with SMTP id t2-20020a05622a180200b003e3c889ecf9mr6254241qtc.1.1685006733903;
        Thu, 25 May 2023 02:25:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6C0uo6zmsXIIx0EZAwr4i+mHtD7VlY7p338AZO4X3ALId/lstT+GC16SI9wyZr4AiQo1SrlQ==
X-Received: by 2002:a05:622a:1802:b0:3e3:c889:ecf9 with SMTP id t2-20020a05622a180200b003e3c889ecf9mr6254226qtc.1.1685006733680;
        Thu, 25 May 2023 02:25:33 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-207.dyn.eolo.it. [146.241.242.207])
        by smtp.gmail.com with ESMTPSA id x25-20020ac84a19000000b003ef3129a1a6sm261918qtq.46.2023.05.25.02.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 02:25:33 -0700 (PDT)
Message-ID: <c536fcd795f74016928469be16fe21df8079a129.camel@redhat.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
From: Paolo Abeni <pabeni@redhat.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>, Pedro Tammela
 <pctammela@mojatatu.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>, "David S. Miller"
 <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,  Jiri Pirko
 <jiri@resnulli.us>, Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann
 <daniel@iogearbox.net>,  John Fastabend <john.fastabend@gmail.com>, Vlad
 Buslov <vladbu@mellanox.com>, Hillf Danton <hdanton@sina.com>, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Cong Wang
 <cong.wang@bytedance.com>
Date: Thu, 25 May 2023 11:25:29 +0200
In-Reply-To: <CAM0EoM=T_p_-zRiPDPj2r9aX0BZ5Vtb5ugkNQ08Q+NrTWB+Kpg@mail.gmail.com>
References: <cover.1684887977.git.peilin.ye@bytedance.com>
	 <429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
	 <faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com>
	 <CAM0EoM=T_p_-zRiPDPj2r9aX0BZ5Vtb5ugkNQ08Q+NrTWB+Kpg@mail.gmail.com>
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

On Wed, 2023-05-24 at 12:09 -0400, Jamal Hadi Salim wrote:
> When you have a moment - could you run tc monitor in parallel to the
> reproducer and double check it generates the correct events...

FTR, I'll wait a bit to apply this series, to allow for the above
tests. Unless someone will scream very loudly very soon, it's not going
to enter today's PR. Since the addressed issue is an ancient one, it
should not a problem, I hope.

Cheers,

Paolo


