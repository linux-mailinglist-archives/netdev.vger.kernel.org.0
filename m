Return-Path: <netdev+bounces-10515-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E56A172ECC0
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 22:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C312280D00
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D4C3D3AD;
	Tue, 13 Jun 2023 20:19:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48E4136A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 20:19:01 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BCA1FD4;
	Tue, 13 Jun 2023 13:18:55 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-98220bb31c6so377826566b.3;
        Tue, 13 Jun 2023 13:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686687534; x=1689279534;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xWHlm3foeozIT3gQKHzclsJqDsELfIpGxkKstipImLg=;
        b=Ka+WWflcuLjSB0VGojDYBsHsyeBTgHMfd69b3EwWp4jZtk5SWhEnWPCmeHOdwq1REw
         ol2b+1m4f9Xm/SGkQLvh1fJAp2ubIBjcBncPprqMtr3YjJqquOPIGlPDrsfV/dkZIaN+
         WWEuRIygJUapxIaXAUZweyT7NDfcZKurwsyZB3hmFIKDZlRPwFutz+ldlLYjIBIWTlOG
         I8/dSfsiXuTZ0KDLSId3QzYsLAC7mLcEvr6I7MJc0iuNM77mL7UYmeBAuzr2GaRAdpfl
         p+X5DsX2WkaypWve/aw1A0o8JXT4vuamCQNXkIZ9CzRje/cVDmsmA/DBU4yJ3zmA+Yi/
         rDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686687534; x=1689279534;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xWHlm3foeozIT3gQKHzclsJqDsELfIpGxkKstipImLg=;
        b=g0EECEiBSrtJRtp3ttIpW+D8zWgOncO+F0FB/agt4d/jgDyyLTO1N4UR2aA5IBv8sN
         Pyv2Sen31qObeZ3CLonHhbXT4BFTPdQRHoP+/6HMQkp2e7UdLCxkBXP0l7Gk5JcF8h7L
         aOeY76qeBCV1J6yUnh4+BxTW9f84jf4Ay/OMoSMEO2amNC5hMwsd5blyb4sch6V9BdJU
         ba0jrBsAK06Wj5svG8EeAkcO58aLH3Il7R+MsFL2U6aZIUhB0/sl6TkWu76G/88zoRA5
         AzO/fT0sWaAOXLLUs2Wrb9Z38P8YtUx/0ICfF1auA4uUwxTB0LLkNk+67kJUQ1nl7v5/
         1Qpw==
X-Gm-Message-State: AC+VfDyugd7l74wjXe70shJRDt8ZpdqtIFozbw1RBqg34uCsOMQ5Qrs6
	RuifydwTO6pG7BoAloQD1UU=
X-Google-Smtp-Source: ACHHUZ5ZBAC47znIwQVNEFkU97eFrP8wiDpgRIrF+opXt+kOS4q+ZpMOLCWAnbpeHi/5j6mfW4Lnfw==
X-Received: by 2002:a17:906:fe43:b0:978:9b09:ccaf with SMTP id wz3-20020a170906fe4300b009789b09ccafmr14962678ejb.14.1686687533889;
        Tue, 13 Jun 2023 13:18:53 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id z6-20020a1709060ac600b009745ecf5438sm7029845ejf.193.2023.06.13.13.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 13:18:53 -0700 (PDT)
Date: Tue, 13 Jun 2023 23:18:50 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames with
 multiple CPU ports on MT7530
Message-ID: <20230613201850.5g4u3wf2kllmlk27@skbuf>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
 <20230611081547.26747-2-arinc.unal@arinc9.com>
 <20230613150815.67uoz3cvvwgmhdp2@skbuf>
 <a91e88a8-c528-0392-1237-fc8417931170@arinc9.com>
 <20230613171858.ybhtlwxqwp7gyrfs@skbuf>
 <20230613172402.grdpgago6in4jogq@skbuf>
 <ca78b2f9-bf98-af26-0267-60d2638f7f00@arinc9.com>
 <20230613173908.iuofbuvkanwyr7as@skbuf>
 <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <edcbe326-c456-06ef-373b-313e780209de@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 08:58:33PM +0300, Arınç ÜNAL wrote:
> On 13.06.2023 20:39, Vladimir Oltean wrote:
> > Got it. Then this is really not a problem, and the commit message frames
> > it incorrectly.
> 
> Actually this patch fixes the issue it describes. At the state of this
> patch, when multiple CPU ports are defined, port 5 is the active CPU port,
> CPU_PORT bits are set to port 6.
> 
> Once "the patch that prefers port 6, I could easily find the exact name but
> your mail snipping makes it hard" is applied, this issue becomes redundant.

Ok. Well, you don't get bonus points for fixing a problem in 2 different
ways, once is enough :)

