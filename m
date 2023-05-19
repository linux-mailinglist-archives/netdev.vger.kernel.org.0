Return-Path: <netdev+bounces-4040-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 408BF70A383
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 01:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C913281B09
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B20E6FA1;
	Fri, 19 May 2023 23:54:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F91710E2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 23:54:11 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D1A1B3
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 16:54:10 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-51190fd46c3so1683507a12.1
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 16:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684540448; x=1687132448;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P4ZjwKmt1k3Lilj42pi0wDxXr6hzicWG/oeowWsHAps=;
        b=Itl8/yR/iecI8ZEYPhkEJowXnV3u9FFzLBU9649+7ombbh6rZ1wWJ4GuR4Z1qdnsUU
         j4sEJPFPLVC92EAWSJg/wFuvswtv/3WBr8cdjkw8ieD2UqlQQNMcQydobvWRzryYtTF3
         +H2HUw92HyOfKfJ6DnAk8bnnHnmI0oFxvqOdimBpXbO9yvPbT7itPeEv7AGQ/DgGZ6UI
         KEjoDFZlgAs75VYiPhQFUgPBqhwfCA3UC2mFLDlf8Y4UkY+bW6dT+d89CILv3qDUnAlh
         c0uoQg17MVH6vhj9OX9/RBYSzR9YHUlA1Fais292pllqyreJUxzx0OsndCbGGF3e7RBH
         6MAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684540448; x=1687132448;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P4ZjwKmt1k3Lilj42pi0wDxXr6hzicWG/oeowWsHAps=;
        b=NyaPg4PhdYxPQYet+7IPxBsyzBvUWuMfG9JaA4YrVG1CSknf9twhQabjeid41Sq5uT
         aJcCfywfjCAUlnZABvWqPnLgq4J5KsjSMw6ThZXm6ayauqxzaGY2f3NeN41N1Ylok7i6
         DjoPbrZRS57g6KfwAEPdPykt/5GC3Oe0QuXLpeCVf6x7GQMo1VBXokIoC8H8lvDQCdgl
         akw4A+xms50zwsJ1UpFddXSSWbyAhLKXle8YDnjCG/OLVHdN5fs1rinXjIXy/hJ3ovOs
         6aRlLmaE9pE2jxPmofcLKcTFetBKuQs7+h1xydFfytTMWjpbxdw4jxnUFhs/ikAtWKTC
         5hcA==
X-Gm-Message-State: AC+VfDzT4ZRfU5nCfvPpLr2vSiLg+9Fg/2y8Go9STNqhbG1P2kfHuVGL
	HoW/7KI+t5vr5LatinWDlFs=
X-Google-Smtp-Source: ACHHUZ4TceqZiPdXx63PGRcPWKfwPbFrJuuEmaXpH+P08+0Gz+xASqO6C2R5XhxgJRfbZJQV3rdPKg==
X-Received: by 2002:a17:907:9955:b0:947:ebd5:c798 with SMTP id kl21-20020a170907995500b00947ebd5c798mr2666279ejc.54.1684540448341;
        Fri, 19 May 2023 16:54:08 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id q19-20020a170906941300b00966293c06e9sm173807ejx.126.2023.05.19.16.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 16:54:08 -0700 (PDT)
Date: Sat, 20 May 2023 02:54:05 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Frank Wunderlich <frank-w@public-files.de>,
	Felix Fietkau <nbd@nbd.name>, netdev <netdev@vger.kernel.org>,
	erkin.bozoglu@xeront.com, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	John Crispin <john@phrozen.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>, mithat.guner@xeront.com
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230519235405.la4inpjqwk5wq7wx@skbuf>
References: <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15>
 <20230228115846.4r2wuyhsccmrpdfh@skbuf>
 <91c90cc5-7971-8a95-fe64-b6e5f53a8246@arinc9.com>
 <20230517161028.6xmt4dgxtb4optm6@skbuf>
 <e5f02399-5697-52f8-9388-00fa679bb058@arinc9.com>
 <20230517161657.a6ej5z53qicqe5aj@skbuf>
 <d2236430-0303-b74c-2b35-99bef4ac30a1@arinc9.com>
 <d2236430-0303-b74c-2b35-99bef4ac30a1@arinc9.com>
 <20230518142422.62hm5d4orvy7nroz@skbuf>
 <e140cec6-132c-0e3a-d48a-88cd176b9875@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e140cec6-132c-0e3a-d48a-88cd176b9875@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 12:00:17PM +0300, Arınç ÜNAL wrote:
> > 		mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_EN | MT7530_CPU_PORT_MASK,
> > 			   MT7530_CPU_PORT(0));
> 
> If I understand correctly, the MT7530_CPU_EN bit here wouldn't be modified
> since it's not on the set parameter.

"mask": which bits are affected by the read-modify-write (rmw)
"set": which subset of "mask" remains set (the other subset, mask & ~set,
remains unset)

So no, MT7530_CPU_EN is not unmodified; it is quite cleared.

> On top of this, I believe we can completely get rid of the else case.
> The MT7530_CPU_PORT bits will be overwritten when there's an active
> CPU port so there's no need to clear them when there's no active CPU
> ports. MT7530_CPU_EN might as well stay set.

Sounds plausible.

