Return-Path: <netdev+bounces-10449-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5455672E8D5
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A46B1C20880
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089B92A6FD;
	Tue, 13 Jun 2023 16:52:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BE833E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 16:52:21 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B1D1BC0;
	Tue, 13 Jun 2023 09:52:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1686675089; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=g8sIDYZGereRM50ZTGnVkERCjlSLgS84Fc8GUN38DSdlYceqrjaIwy4rKt+fvySpwwlU6u/HzPz2pkkVC+SnbMyYzOOxFcg0YUm3PPt+wbX/mqLRTRgW1YaGBrveTEuyR5IHbKKoCRvb2N8rl6v1RWuJIC91Is49ahRtC2ds/VM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686675089; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=Y0/36EZqu1xosxR6JgPWMg2E2J6XN23PQ/8eX+lJwko=; 
	b=h4nR4dK/1dIc8H4QcEdxgS9Bgx4F4eUElHUNwakx1ADRI96k9toJrKIQAxo7YLStwhkF6CLF6zvzKKJcLama7DcAQ+Y/C3x1ZPr3MaKR/zDHj2hIazfZbg2reRzj8mw2MgLeppDaJYUghmMdexWhEQDClH73zZKOU6WaNCb+kic=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686675089;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Y0/36EZqu1xosxR6JgPWMg2E2J6XN23PQ/8eX+lJwko=;
	b=FIjQSjg8/TvDzMpYU6IAzj8KOtwW5U9tZNHcHh2056qGMwnBGBnyvpDPlP9yICqY
	4qZVCDNalgNNlILFleCo0IECcodNBkHheHAHHbj6lMinFzhwG1gs4el2KqmEv2RLuKJ
	MGwS6z5hLm1mz0efUH7pyA9/LfnqZil6zyt01hCw=
Received: from [192.168.1.248] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 1686675088239538.3959980724251; Tue, 13 Jun 2023 09:51:28 -0700 (PDT)
Message-ID: <3a8ff694-efdb-3ec0-c932-df681ef930cd@arinc9.com>
Date: Tue, 13 Jun 2023 19:51:18 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v4 0/7] net: dsa: mt7530: fix multiple CPU ports, BPDU
 and LLDP handling
To: Andrew Lunn <andrew@lunn.ch>,
 "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Daniel Golle <daniel@makrotopia.org>,
 Landen Chao <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Sean Wang <sean.wang@mediatek.com>, Florian Fainelli <f.fainelli@gmail.com>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, mithat.guner@xeront.com,
 erkin.bozoglu@xeront.com, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <ZIcDee2+Lz7nJ3j6@shell.armlinux.org.uk>
 <ZIeFjdxctcR4yRLZ@shell.armlinux.org.uk>
 <66751af3-db5e-432a-859f-97e54c930e00@lunn.ch>
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <66751af3-db5e-432a-859f-97e54c930e00@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 13.06.2023 00:30, Andrew Lunn wrote:
> On Mon, Jun 12, 2023 at 09:52:29PM +0100, Russell King (Oracle) wrote:
>> On Mon, Jun 12, 2023 at 12:37:29PM +0100, Russell King (Oracle) wrote:
>>> Hi,
>>>
>>> Please slow down your rate of patch submission - I haven't had a chance
>>> to review the other patches yet (and I suspect no one else has.) Always
>>> allow a bit of time for discussion.
>>>
>>> Just because you receive one comment doesn't mean you need to rush to
>>> get a new series out. Give it at least a few days because there may be
>>> further discussion of the points raised.
>>>
>>> Sending new versions quickly after previous comments significantly
>>> increases reviewer workload.
>>
>> And a very illustratory point is that I responded with a follow up to
>> your reply on v2, hadn't noticed that you'd sent v4, and the comments
>> I subsequently made on v2 apply to v4... and I haven't even looked at
>> v3 yet.
> 
> Hi Arınç
> 
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#netdev-faq
> 
> says:
> 
>    don't repost your patches within one 24h period
> 
>    2.6.6. Resending after review¶
> 
>    Allow at least 24 hours to pass between postings. This will ensure
>    reviewers from all geographical locations have a chance to chime
>    in. Do not wait too long (weeks) between postings either as it will
>    make it harder for reviewers to recall all the context.
>   
>    Make sure you address all the feedback in your new posting. Do not
>    post a new version of the code if the discussion about the previous
>    version is still ongoing, unless directly instructed by a reviewer.
> 
> During a weekend, i would say 24 hours is way too short, and 3 days is
> more like it, given that for a lot of people being a Maintainer is a
> day job, 9-5 week days.
> 
> You should also try to gauge how fast Maintainers are reacting. 24
> hours is often too fast. You know Russell is interested in these
> patches, so don't send a new version until you actually get feedback
> from him, and the discussion has come to a conclusion.

Understood, thank you both for the kind warning.

Arınç

