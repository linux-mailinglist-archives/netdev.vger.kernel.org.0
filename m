Return-Path: <netdev+bounces-7034-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5F687195A8
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C3E71C21040
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7FC179DF;
	Thu,  1 Jun 2023 08:33:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD225250
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:33:12 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C4E10E9;
	Thu,  1 Jun 2023 01:32:50 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-96f5685f902so67818366b.2;
        Thu, 01 Jun 2023 01:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685608369; x=1688200369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SGeZcj/xqFdBCAsFRsR5LjFS8WiTXlKQmU3ozKW5lR0=;
        b=mXU+LX1Wxnt6lmvGgkf7+2noyrxmQpFer4WKZxeN/tx7ikKz/G6AgGOIAokKOIJxIp
         VF7jwBKqZQNlgyRIc50qizrWT5M7wzM+RvEL1r1lOVTzQ0TtG2BzIBHjTJCMIhwSEKl4
         tN32MBRJvSmNGj8BhsJiOZTcaDFFcrXbCB0iH2nxcOU5FHuCCCwTXL+31AI1cK7IUtnC
         x+kg/RjRjnkCDKRHVgzW9QEhOlVFKzySFCuTLjg19WXPnExT+qy52g4oVp9RJZWHe5qj
         +62Is6FZMt6/fHZ9XMqRoW7toH7111CGjgtPJ3QrMjsBvWjHh0lYUxQwyADa7HVjc64o
         wC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685608369; x=1688200369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SGeZcj/xqFdBCAsFRsR5LjFS8WiTXlKQmU3ozKW5lR0=;
        b=Jf3vDRUCsAb6qWJkmwsDk2dVQljoJd+Us2Vz8EL2U2CEl1ABR4pWs/hrl4M8gVDEGw
         PKRbjqIq8ASpCyTU1GQPWVlO7CxNbBD+XGDSIfvJmfU0pGGmNXFli8m+VfFlozPDrDWV
         kwVXIarbYRhyOlHcggbe+MGsfrgQW+U/kU7kObnmba4UMANMORWerhPRffx7Bqgm5fpo
         JrRbPtQz/i5XeZ2kt1SnUHiUXI4TqSVy+yuHUmh/zPlVRhu4GoVSZ1c9bvFuQYTcDbpU
         qzOljsxHQ6i04Dg6xXEZmfWpk4YJXz2GZyzoSisH+LYRfHQlB9OZOX88FReUEOxbY7yW
         /0xg==
X-Gm-Message-State: AC+VfDwqQbguCKveVBWI9AcvgoDbf+Lby7S3COLlq8JHGu4QIkSlblb3
	xBajS/IkwnS9VobAKFurJc6eUHPAQhpp0A==
X-Google-Smtp-Source: ACHHUZ7lWbhSWAvgjHtzXmXkJka4X6rAwGfYs04sUm+XtpQRB4f/nLQx2GdQ2dSelz67MmLr5qBGtg==
X-Received: by 2002:a17:907:9406:b0:94a:845c:3529 with SMTP id dk6-20020a170907940600b0094a845c3529mr7095765ejc.9.1685608368467;
        Thu, 01 Jun 2023 01:32:48 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id a17-20020a17090680d100b0096739e10659sm10215611ejx.163.2023.06.01.01.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 01:32:48 -0700 (PDT)
Date: Thu, 1 Jun 2023 11:32:46 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>,
	"privat@egil-hjelmeland.no" <privat@egil-hjelmeland.no>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>,
	"andrew@lunn.ch" <andrew@lunn.ch>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: lan9303: allow vid != 0 in port_fdb_{add|del}
 methods
Message-ID: <20230601083246.3ll6b5l7pqoazbir@skbuf>
References: <20230531143826.477267-1-alexander.sverdlin@siemens.com>
 <20230531151620.rqdaf2dlp5jsn6mk@skbuf>
 <426c54cdaa001d55cdcacee4ae9e7712cee617c2.camel@siemens.com>
 <20230531153519.t3go47caebkchltv@skbuf>
 <20230531214150.2e0f03d1@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531214150.2e0f03d1@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 09:41:50PM -0700, Jakub Kicinski wrote:
> On Wed, 31 May 2023 18:35:19 +0300 Vladimir Oltean wrote:
> > If you want to be completely sure I didn't just throw a wrench into
> > your plans, feel free to resend a v2 with just my review tag
> > (dropping my Fixes tag)
> 
> FWIW if you worry that the Fixes tag will get added automatically - 
> for whatever reason that still doesn't work. We add them manually
> when someone provides a tag in response.

Aha, ok. So as long as the maintainer who applies the patch does not
append the second Fixes: tag that I had proposed, all is well and this
change can be applied as is.

