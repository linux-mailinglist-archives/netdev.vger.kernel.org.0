Return-Path: <netdev+bounces-8273-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B8677237D8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:37:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AEFD1C20E21
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 06:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EADD813;
	Tue,  6 Jun 2023 06:37:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948DC190
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:37:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449A118E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 23:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686033469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zxLXKEc9MLQA6mmw9F+BITbGu41Zfcf8gwRJWcsxTFI=;
	b=IJtjcUw6J5H7p9FX5LVuYsFK06R49oxQ4AHSPTnjdFi7L9mK5a51EVJvQThKHeblobAVBw
	F+mkGthLAvUV08xWYf8++bVk0wgCyQnz/sLDxbojSxRr2nfjm4qY+tVLi4lvJMakyobzc5
	kdDGtCFs5ySaDSNZrK1Sn7NK166X5lM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-oKKLmCY1OpuDdFBd8Shezg-1; Tue, 06 Jun 2023 02:37:48 -0400
X-MC-Unique: oKKLmCY1OpuDdFBd8Shezg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f736116989so11880525e9.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 23:37:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686033467; x=1688625467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zxLXKEc9MLQA6mmw9F+BITbGu41Zfcf8gwRJWcsxTFI=;
        b=U/HIJfzYFwXAnlWrWMMuqsEHKXuiJpGKAY2tkWD4OAxyunZh1nYlQLOomv8d30u02I
         6m/ZMsP+D7VERfpHQfvYWZ11Q2/BZfL3Sau7kQsVv3mbR0qCCYwSnQ+mNGlktBxBZWE1
         83D6cOqEVN/pBA3NhrXP1VrbDI4GvhTz5UcJa5Wi39iyi1I7vU7XPn6ZAF81cagyt5in
         d7Zo0zzJJnhJqXqa5TzqbgFbo5KPOMwsEfoaUl009qz0DVkUvi7hcKCwhfN/xDT7uV7o
         WHsSFkFVCi6yGl55eoqcIniImMiS1vksl9/QmvwIgwHu/MkTqhboKEP3npa3v8J/xPsI
         hAZQ==
X-Gm-Message-State: AC+VfDxJkDYDMR8F02skrRyTfD9jFxcJT5OIxVE1mwx8sOIE8h7IBb4v
	GId84cQA/10D6HGIwyUfc5sZhtawn8+rpB3c7Cmhh9A0DQ9hWIhp+GfZyhACw67eEJnEHvS6Svf
	E0uNzp6iUUCKvs+eR
X-Received: by 2002:a1c:720e:0:b0:3f7:e7a2:25f6 with SMTP id n14-20020a1c720e000000b003f7e7a225f6mr862011wmc.17.1686033467313;
        Mon, 05 Jun 2023 23:37:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Py5Zil0TZm/r9utHe1u4fh4cPXECYWPlX9hglPnlCr8sCdKGbq7LQ7DEBVobj0+YQEDO3dA==
X-Received: by 2002:a1c:720e:0:b0:3f7:e7a2:25f6 with SMTP id n14-20020a1c720e000000b003f7e7a225f6mr861989wmc.17.1686033467060;
        Mon, 05 Jun 2023 23:37:47 -0700 (PDT)
Received: from localhost ([37.163.159.94])
        by smtp.gmail.com with ESMTPSA id e7-20020a05600c218700b003f42328b5d9sm12929077wme.39.2023.06.05.23.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 23:37:46 -0700 (PDT)
Date: Tue, 6 Jun 2023 08:37:42 +0200
From: Andrea Claudi <aclaudi@redhat.com>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com,
	David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v8] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZH7UNicnz1GG4uKB@renaissance-vector>
References: <20230606023202.22454-1-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606023202.22454-1-vladimir@nikishkin.pw>
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 10:32:02AM +0800, Vladimir Nikishkin wrote:
> Add userspace support for the [no]localbypass vxlan netlink
> attribute. With localbypass on (default), the vxlan driver processes
> the packets destined to the local machine by itself, bypassing the
> userspace nework stack. With nolocalbypass the packets are always
> forwarded to the userspace network stack, so userspace programs,
> such as tcpdump have a chance to process them.
> 
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>

Reviewed-by: Andrea Claudi <aclaudi@redhat.com>


