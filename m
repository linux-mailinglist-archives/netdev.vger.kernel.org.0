Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B40382A01
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 12:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbhEQKki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 06:40:38 -0400
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:4064
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236218AbhEQKki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 06:40:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjttU68hyAu4erPbmAJbG7t0kMi+RuFRrSzsAe9h2Uc4KKwLJasOiTVuEMN1s1dP2sNVrvxT/TPSUGJlLnhEeebtqqRYj+VGVOKSl7NKVPJwsGCS28lCuwAz8SFlELHi6hCQU9N7+KWI1JVM/DK/haKtNm5UgbiLz/atHm9EhgcR4sQtxj62emCOUyxxZE9XZ5bKgfhUHLulxNcxE3nQA+peP9kN/dGomaucv9YCqvpdrACZTzNW7QwLgdURGSR/nxZvKK4421vfIAINnFmKhBAzGgkC+zMVBYIPclaq2O7IIU5+TJwyS4bQvxwF5CVFWq9p6qTSGN7AK0b8I1OGzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3jHq3xlrZjByozSn8ZywJKlTEiceJKi63pdXXvitSw=;
 b=b3ILH0Gc4kiuljQ7ltp46ygz6EmjiOXC3ODJIxkL4L+hJrS7aym4Hx+qQxD4nkjclsJJ5sKn6Uok6bp+IQXY5VOFFLMp4+xzFx6Wm970IGRQHofBNocgNsKJsBUgdirQnhC9KNnJUdY5JjEgVAYp70OIVolpVmq0jhHfEmz6HbR/tnZPL9waQxBcpJR8OxVtplthTP1toh67fQmMEBxQoBWT3Dtd2ySvfxEWAiacd1Q18+5WGzvBYW1CRAZf2FgdzOlxuc2FOnGq9hbnA2umc1M0BNDfIgfOORX2sVJL9I5uBmQFibjG4hwuqqw4zjU2X7+nRhYE0AMIfWmefaP7PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=foss.st.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3jHq3xlrZjByozSn8ZywJKlTEiceJKi63pdXXvitSw=;
 b=GJlpt7yhJgq9qUFqYCtmI5tZlGYMmRRU+sjH0Z647tjiFAmxv45A8DV46BPIgdetYzolED37rvRfvERr2TuCsgS5av4Vg/VfCiHXc2viIPfd4nYDd74F0NDafTKle8++m6DKj4QzPx+PNadhPnI2Bmo0Wzae9WKjjHGuBL5cEjVGEXRn7h7dbWRSBF+XSk4uRXlzbah+Nc5KMebmtcg9wotMX8F/zggbQFx6JBrmq+ayGHKtYtf0/U07pq2Fx6dwOZpWb9aP1aY5vLfvR7GiU+jtQJYNszRWFFxyQjNl33Z6yicVWvuGxyVx/c9rGoiCipfZ0aWBO8Z4ASrxZ6z48g==
Received: from DM3PR03CA0002.namprd03.prod.outlook.com (2603:10b6:0:50::12) by
 MW3PR12MB4505.namprd12.prod.outlook.com (2603:10b6:303:5a::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Mon, 17 May 2021 10:39:19 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:50:cafe::36) by DM3PR03CA0002.outlook.office365.com
 (2603:10b6:0:50::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 17 May 2021 10:39:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; foss.st.com; dkim=none (message not signed)
 header.d=none;foss.st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 10:39:18 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 10:39:16 +0000
Subject: Re: [BUG] net: stmmac: Panic observed in stmmac_napi_poll_rx()
To:     =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
References: <b0b17697-f23e-8fa5-3757-604a86f3a095@nvidia.com>
 <20210514214927.GC1969@qmqm.qmqm.pl>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <b9a1eef5-c515-e905-9328-9024c3472e29@nvidia.com>
Date:   Mon, 17 May 2021 11:39:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210514214927.GC1969@qmqm.qmqm.pl>
Content-Type: text/plain; charset="iso-8859-2"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecc164ae-8b72-4261-d6fa-08d919200676
X-MS-TrafficTypeDiagnostic: MW3PR12MB4505:
X-Microsoft-Antispam-PRVS: <MW3PR12MB450596DCD1B3509B86E1C324D92D9@MW3PR12MB4505.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D92E1kaMt8r7oXrUIWf9rhpaOvmEvA4WAAMszW1cvb2b/ohNfR3mIO86UuYvwVfCmsIi57ZRS4d4tWBnqBAmbBsW3IpDeovXUErgHMd2VkRR49yc6IJCsoREiSmLwYzawbUHyvxhbTsy7e4yDmw1aNqQJA8kPiEnv4rCZS+9tXKHeeRH2ZBIeXbkIqqoAr5LaJtZWEfuJDsuIGOsBjXy2nbBDVYXysXmLu/aKffA3ZAt/FozzQs38kMRRKko0KwhOmEqcStYG9PoSGl8VaBEFjiHaC7WWffWjByA/hSvxXrqJNFil4MLOampWrkxn9XWTjX/ftJlotjH6yBEnrFvReiJfhx56/W9HANdjumq30OHmBjT72yBz296IijvLgVO1T8VY0DyRHJrsXM08zlDB2UM0JMGof017Wl/3ZDkq/4HcKx1nehWYnFgpISm28gbsIYM23cjKbx/0fBP+pIniv1dRFiaSPkwYnag1AojbIagJgWohTCcC00XuipT78hwaMEqj2odGi25++2jqZYsDibIMk6eCu3wgjlkM6eOUgg//+uoX9XqtygCkuDTNR8diQbi7oKuTz7FVy9TWDVe4hyUDCAs9kteOu74C90qXazBKOuQdhl8oqimKXSMuajQ27mM2CPjN58qQE2c7mGn4wwoPgI5twQEwZSnh/COh0ujoljZFC2XQ67t5J2tIVQd
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(46966006)(36840700001)(70586007)(5660300002)(186003)(70206006)(36860700001)(36756003)(31686004)(4326008)(426003)(86362001)(16526019)(54906003)(7636003)(478600001)(336012)(2616005)(66574015)(6916009)(47076005)(31696002)(53546011)(36906005)(16576012)(2906002)(107886003)(8676002)(316002)(83380400001)(82310400003)(356005)(8936002)(26005)(82740400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 10:39:18.6585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecc164ae-8b72-4261-d6fa-08d919200676
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4505
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/05/2021 22:49, Micha³ Miros³aw wrote:
> On Fri, May 14, 2021 at 03:24:58PM +0100, Jon Hunter wrote:
>> Hello!
>>
>> I have been looking into some random crashes that appear to stem from
>> the stmmac_napi_poll_rx() function. There are two different panics I
>> have observed which are ...
> [...]
>> The bug being triggered in skbuff.h is the following ...
>>
>>  void *skb_pull(struct sk_buff *skb, unsigned int len);
>>  static inline void *__skb_pull(struct sk_buff *skb, unsigned int len)
>>  {
>>          skb->len -= len;
>>          BUG_ON(skb->len < skb->data_len);
>>          return skb->data += len;
>>  }
>>
>> Looking into the above panic triggered in skbuff.h, when this occurs
>> I have noticed that the value of skb->data_len is unusually large ...
>>
>>  __skb_pull: len 1500 (14), data_len 4294967274
> [...]
> 
> The big value looks suspiciously similar to (unsigned)-EINVAL.

Yes it does and at first, I thought it was being set to -EINVAL.
However, from tracing the length variables I can see that this is not
the case.

>> I then added some traces to stmmac_napi_poll_rx() and
>> stmmac_rx_buf2_len() to trace the values of various various variables
>> and when the problem occurs I see ...
>>
>>  stmmac_napi_poll_rx: stmmac_rx: count 0, len 1518, buf1 66, buf2 1452
>>  stmmac_napi_poll_rx: stmmac_rx_buf2_len: len 66, plen 1518
>>  stmmac_napi_poll_rx: stmmac_rx: count 1, len 1518, buf1 66, buf2 1452
>>  stmmac_napi_poll_rx: stmmac_rx_buf2_len: len 66, plen 1536
>>  stmmac_napi_poll_rx: stmmac_rx: count 2, len 1602, buf1 66, buf2 1536
>>  stmmac_napi_poll_rx: stmmac_rx_buf2_len: len 1602, plen 1518
>>  stmmac_napi_poll_rx: stmmac_rx: count 2, len 1518, buf1 0, buf2 4294967212
>>  stmmac_napi_poll_rx: stmmac_rx: dma_buf_sz 1536, buf1 0, buf2 4294967212
> 
> And this one to (unsigned)-EILSEQ.

Yes but this simply comes from 1518-1602 = -84. So it is purely
coincidence.

Jon

-- 
nvpublic
