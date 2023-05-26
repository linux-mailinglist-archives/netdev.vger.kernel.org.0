Return-Path: <netdev+bounces-5766-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8248712B31
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:56:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EDE41C20FD8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C972027736;
	Fri, 26 May 2023 16:56:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1112CA6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:56:03 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932C212A;
	Fri, 26 May 2023 09:55:53 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-514859f3ffbso319530a12.1;
        Fri, 26 May 2023 09:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685120152; x=1687712152;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BVB1oaEqb0nCh7/TkolrkD30I0YxpmZoZt03ZQMqTUU=;
        b=HOONLSKAnH/QqPHu9WT2rWuKt7J+3VuaOtzRIn0ktdQRHt+mj3noIyD8rvM4NEKBQl
         WMe/8Ik+L397mXmmOetDYl3Dk6BdBBRGfQj8TeFbdpfv9m+iui0umv+J07nt1IKaF0YC
         B2AE8wTu7VvhuGrjCwwO52nHkz2NnGL78TWkuOA/znZ4IS/Ze8GjhmoyAIQm390K7gM3
         LxpsB7Yzn+4pxiuKskquw40slwV2sRrES7up5wDCg/fh3PhlTBScEDFRlurN2sK+XtDf
         kK2t4TawNMnAcGtv3LET3DG3PC0gmzxbAYb3el0EQMjjwd8kpJ2JCXTl2YnPlS702HEi
         XfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685120152; x=1687712152;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BVB1oaEqb0nCh7/TkolrkD30I0YxpmZoZt03ZQMqTUU=;
        b=O9aKgkdrJPi2rai3Cprez5kkZTqY1tD0OuHCUgCUUFlioIC1PbYXjiI+zBgCbQt69H
         HfWaySdeW8WwEer3N8Qv+l8O4uIlJ8IhSo5pgrq4Vci7sRkDpRCGCyKWJu/Sp3qTpVM8
         E4xTLyjM4iww5FsBTTeUWdI0fiCnUJLDiawta7aVnYICALi4t6i1xlHS3/L4Y4BI+Bf4
         7SjzlGxS7+yTrTyPtCdxRiITjHCm3zUWBI4t9OLE+sZGlTqIBl/Ghju62IFFpXnRCD6F
         EPUrCp7g3j+RzRY26uEoxBAahe11zJ0UszbqioL16nALCmwdaSeAhHhaAOCur1lJ4drT
         gCuA==
X-Gm-Message-State: AC+VfDz+B/sd0QuOq0j7xko1BiRMLcmqNdMk6OAfZmwZ1yW4VSouYVhy
	JME6X0g9flOQQLRWpN94wvg=
X-Google-Smtp-Source: ACHHUZ4iTjI8KlCBHfyi32LLUWk745b3RNHS4iOVUUpprzoTVHgO/Ljbxr5EdgBITrwa1iNNyX9WyQ==
X-Received: by 2002:a50:fb17:0:b0:514:7a67:44dc with SMTP id d23-20020a50fb17000000b005147a6744dcmr1516263edq.19.1685120151838;
        Fri, 26 May 2023 09:55:51 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402071100b0050c03520f68sm127797edx.71.2023.05.26.09.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 09:55:51 -0700 (PDT)
Date: Fri, 26 May 2023 19:55:48 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: arinc9.unal@gmail.com
Cc: Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	=?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com, mithat.guner@xeront.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 26/30] net: dsa: mt7530: properly set
 MT7530_CPU_PORT
Message-ID: <20230526165548.d6ewov743orxviz3@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-27-arinc.unal@arinc9.com>
 <20230522121532.86610-27-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-27-arinc.unal@arinc9.com>
 <20230522121532.86610-27-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:28PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The MT7530_CPU_PORT bits represent the CPU port to trap frames to for the
> MT7530 switch. There are two issues with the current way of setting these
> bits. ID_MT7530 which is for the standalone MT7530 switch is not included.

It's best to say in the commit title what the change does, rather than
the equivalent of "here, this way is proper!". Commit titles should be
uniquely identifiable, and "properly set MT7530_CPU_PORT" doesn't say a
lot about how proper it is. It's enough to imagine a future person
finding something else that's perfectible and writing another "net: dsa:
mt7530: properly set MT7530_CPU_PORT" commit. Try to be less definitive
and at the same time more specific.

If there are 2 issues, there should be 2 changes with individual titles
which each describes what was wrong and how that was changed.

> When multiple CPU ports are being used, the trapped frames won't be
> received when the DSA conduit interface, which the frames are supposed to
> be trapped to, is down because it's not affine to any user port. This
> requires the DSA conduit interface to be manually set up for the trapped
> frames to be received.
> 
> Address these issues by implementing ds->ops->master_state_change() on this
> subdriver and setting the MT7530_CPU_PORT bits there. Introduce the
> active_cpu_ports field to store the information of active CPU ports.
> Correct the macros, MT7530_CPU_PORT is bits 4 through 6 of the register.
> 
> Any frames set for trapping to CPU port will be trapped to the numerically
> smallest CPU port which is affine to the DSA conduit interface that is set
> up. To make the understatement obvious, the frames won't necessarily be
> trapped to the CPU port the user port, which these frames are received
> from, is affine to. This operation is only there to make sure the trapped
> frames always reach the CPU.
> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Co-developed-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

A single Suggested-by: is fine. As a rule of thumb, I would use Co-developed-by
when I'm working with a patch formally pre-formatted or committed by somebody else,
that I've changed in a significant manner. Since all I did was to comment with
a suggestion of how to handle this, and with a code snippet written in the email
client to a patch of yours, I don't believe that's necessary here.

> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

