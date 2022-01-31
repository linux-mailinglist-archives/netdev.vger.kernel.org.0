Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6814A3F79
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 10:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238883AbiAaJp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 04:45:29 -0500
Received: from mail-eopbgr140042.outbound.protection.outlook.com ([40.107.14.42]:17915
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237067AbiAaJp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 04:45:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0NZr30cx5KhMVZY5HNQp5nbpLbmLzrS77C8TGeFpWBV7HLyiayb7vC3OhY5EXZ0+zewIUkY1Xlm5RfPSpJ+/2D056H8n1mP/v6WFWiM8pNpOoJXC4a847Bu7QPjYItLLHsa30WEs6p9zIfZxSbpYGYY1KTulmGCqMXc1DOBVef5bi8fFhcTFBkD8ox54pBvnbC6EnwwTCtjRfry1AOf1ye5h4jLOVFVSQ3n7mY8EH+VbwkOjE7gwgVs9iD/4oJQwiBrJsqYGVf8R0UL27+vBNdqXEgK6ZYPpiDc3dTr2PNt1Wk9nC80znd2fIK/4Je8Rp/5QF54KItwTzrvdoswiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOWvio7s9XAQKQgBO74aZuGa8UXYgQEgpXMZc4Y+teM=;
 b=getpDuYLB5u7fr3ZK/TnGK08m5Ys917JFGh3WJsT2AflNY9umDkWQmaEi1dJ+HxhImTJ8PGoS0bFp9pRmcyU5DtucCVPtABPqJ/PJZDZOK7gg88hkLBUY/8umPqMRSY/2S7N9fNaqKL3ynyUx3yKloStjd2yOgu7IzIa6x9j/IaIO8G0RQRPAQCITv8nIL6kEWaw8kq5V0yX7WvIIKPdhqiQOfYobv6T6QUDYidFITa3bcuReVYVxZZjhACI/KAL4z0JOeXUupheqnP94U3mwKWque6+pXjsY74P1TxQUZ14L7hSyrWsLgeY6aJTo4GCRP36C8c6VVpTaE6VprFFRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.72) smtp.rcpttodomain=abv.bg smtp.mailfrom=siemens.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=siemens.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOWvio7s9XAQKQgBO74aZuGa8UXYgQEgpXMZc4Y+teM=;
 b=cLKrJginMimnTuaNw1h5mErUDBD7rFX9JoIOYKCqmO85kffYryHahCgiE1Z3emeT5Jwsb5BUv9bVC1sal2jF57eWm5obd5YX6txi8JzRprs8XgM7OdVeovajhEFY7Tezfge56k5jcEnTU8l8c3V94VApRUHr58khq3+1hyRJTB5LpQRNENuCKkc22U4WBZ8MxusLQl/2Y7562jBn408UVeyjxVw1pgwt1Iz0QfXL5wK9lVd+jAj9QJapXdRKeqvi796W/ZWvpf4fhurqA1VxHbIzPz5XkGAwvTnpq7UMsmqdYZTy/tkupyjWP04t+YYmR1t36/z+RjKHyiduab8UqQ==
Received: from DB6PR0802CA0028.eurprd08.prod.outlook.com (2603:10a6:4:a3::14)
 by PAXPR10MB4874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:201::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 09:45:26 +0000
Received: from DB5EUR01FT046.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:4:a3:cafe::bc) by DB6PR0802CA0028.outlook.office365.com
 (2603:10a6:4:a3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15 via Frontend
 Transport; Mon, 31 Jan 2022 09:45:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.72)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.72 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.72; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.72) by
 DB5EUR01FT046.mail.protection.outlook.com (10.152.5.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 09:45:26 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SMA.ad011.siemens.net (194.138.21.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Mon, 31 Jan 2022 10:45:26 +0100
Received: from [167.87.32.84] (167.87.32.84) by DEMCHDC8A0A.ad011.siemens.net
 (139.25.226.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 31 Jan
 2022 10:45:24 +0100
Message-ID: <80a13e9b-e026-1238-39ed-32deb5ff17b0@siemens.com>
Date:   Mon, 31 Jan 2022 10:45:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Content-Language: en-US
To:     Georgi Valkov <gvalkov@abv.bg>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <mhabets@solarflare.com>, <luc.vanoostenryck@gmail.com>,
        <snelson@pensando.io>, <mst@redhat.com>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <corsac@corsac.net>,
        <matti.vuorela@bitfactor.fi>, <stable@vger.kernel.org>
References: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
 <20210720122215.54abaf53@cakuba>
 <5D0CFF83-439B-4A10-A276-D2D17B037704@abv.bg> <YPa4ZelG2k8Z826E@kroah.com>
 <C6AA954F-8382-461D-835F-E5CA03363D84@abv.bg> <YPbHoScEo8ZJyox6@kroah.com>
 <AEC79E3B-FA7F-4A36-95CE-B6D0F3063DF8@abv.bg>
From:   Jan Kiszka <jan.kiszka@siemens.com>
In-Reply-To: <AEC79E3B-FA7F-4A36-95CE-B6D0F3063DF8@abv.bg>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.87.32.84]
X-ClientProxiedBy: DEMCHDC89XA.ad011.siemens.net (139.25.226.103) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0674e9f-0fa2-4e45-3905-08d9e49e68fa
X-MS-TrafficTypeDiagnostic: PAXPR10MB4874:EE_
X-Microsoft-Antispam-PRVS: <PAXPR10MB48746A89756D8D24003C242E95259@PAXPR10MB4874.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tm8AHexnv+FkLCylnETfbx8eQJIx4R0WAP3FjD5Y24u1R3aPowUsThc7jMSmZNvUyWcs/q0/Ufzj85wzyxLnQAQ7MpCRLxu1ULuOgljOUwd3QNJI51tBW/hxDnwPTg276VY0FF+SigrwRs0k0AODNsMPGxAhRdLjAdpFUmmH0mUq888oa37aaANgNpfLkLWXyux6JN6fYZ9Gcr6G7ITQj0LUfC2aoSEPEvg126C8X3kNcAJN8h7VzLjeJZTE55UeMehLfp737Kjbs2EDtD3ukKzOgt24QwJezdh8MsPlUuCtfHsxS6RsIRlkfooj+vBpDTaAGv2yimsDMpyBFNg4BWKrBwGNpY6enwxqz2ytbIzfUmfcA8qv6uXp5EvHcHhCTFmrqbMMoJE0El73rHW7aIaeIIQfM4I5nJH2NyKzcmmWr5D1X3+coj5tnHSNgVsySzf+LzUbVE+jEe98RtaYDkloqYCh69qLi29sxhCxKJur+EGN++Ehjc1MyTXNtOcv45+EB9cSfV4w1qJeFv2UDvDYgmvNY9JH9pRrYEuTTo4oPeDx+Z3KXJ/R6XLLUsEUlQ1iJzQRF4oulDwMjju33IT3Q8iBBWIdoyTsD3/HHcia9Ef3KQc46Lx68eT522kBTMD2JIx+j+z8KoH9TguIboRZweByS6dQHJ0Xe7kitpxeDom3jlYqByyblLFlm/1FLgn5xqSLI/XqoF2ZJfUy3EiKHlNrg0lkISRtsFey/b2IgTokq6b/7zQFL4hxdk4KOgvXt+y4TDaE5MGIMfGdiA==
X-Forefront-Antispam-Report: CIP:194.138.21.72;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(81166007)(6706004)(54906003)(110136005)(31686004)(508600001)(356005)(336012)(40460700003)(16576012)(82960400001)(316002)(36756003)(86362001)(31696002)(47076005)(36860700001)(4326008)(44832011)(5660300002)(7416002)(16526019)(186003)(83380400001)(8676002)(70206006)(70586007)(82310400004)(53546011)(2906002)(956004)(2616005)(26005)(8936002)(3940600001)(36900700001)(43740500002)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 09:45:26.6086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0674e9f-0fa2-4e45-3905-08d9e49e68fa
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.72];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR01FT046.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR10MB4874
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Georgi,

On 20.07.21 15:12, Georgi Valkov wrote:
> Thank you, Greg!
> 
> git send-email drivers/net/0001-ipheth-fix-EOVERFLOW-in-ipheth_rcvbulk_callback.patch
> ...
> Result: OK
> 
> I hope I got right. I added most of the e-mail addresses, and also tried adding Message-Id.
> I have not received the e-mail yet, so I cannot confirm if it worked or not.
> 

What happened here afterwards?

I just found out the hard way that this patch is still not in mainline 
but really needed.

Thanks,
Jan

>> On 2021-07-20, at 3:54 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Tue, Jul 20, 2021 at 03:46:11PM +0300, Georgi Valkov wrote:
>>> Yes, I read it, and before my previous e-mail that I also read the link from Jakub,
>>> which essentially provides the same information.
>>>
>>> There is only one patch 0001-ipheth-fix-EOVERFLOW-in-ipheth_rcvbulk_callback.patch
>>
>> Great, send that using 'git send-email' and all is good.
>>
>>> The command I used from the example also generated a 0000-cover-letter, so
>>> I included it as well.
>>
>> Why do you need a cover letter for 1 patch?
>>
>> thanks,
>>
>> greg k-h
>>
> 

-- 
Siemens AG, Technology
Competence Center Embedded Linux
