Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9456725443E
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 13:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgH0LWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 07:22:06 -0400
Received: from mail-eopbgr130127.outbound.protection.outlook.com ([40.107.13.127]:40455
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbgH0LQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 07:16:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcwPb08hJ3WF1Zs8m5gPsF2NZpJw77MSoSe2/8wyMjLIyypGjb82O1scbp8NRv3D/mcfbIWKu4Rb7vC+0JTK6P1u+p+mNeuQMpa0Bj48OJ6/OFtClMeCVzZbmQ3kGgk3P/uyBi1p5OmX+ZohzpBdKybcxJpdCsSKSpg89wJ0RSHYNeu5rpt/hGgQ1HrYOLJ7O5xDIlwOhBeT649/fvfVOLrbcToZNgCkmL4qhcxf9uGnnj6kaz7+FWK78CgRCmsmEGEWPyFQI3vRU9HCLz7Oy68hRwzfd8CSLneaNeAUgFj+2M6WUaKHUD9byTzHe4wKbAUL+HduDgS1q+QFqgiZLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZnyOjvzTalhDsM3mFBfV4pUnXsek/CWUgCKYOpsAo8=;
 b=NulRcVMGUERgm/kBnvyUsTuZhEV5TojA7tRqW7PpFJB/WRxkLWlWnxvdlmsZGE61f1bdqTEHmdw9py+jZJBtzqo0EzAnbHWPt8EslXM2x60RIZ4UneU/QtzfhwV9QT9trvY3pz4ygDoasG3LERfEhta/xobh2yR0sNiQa1oVjdezsRTYuo8lKuv3xfQU4JtLAFWbr8ISOu9MyAZwrA04OinYIGc4gUQFjPqLR/zz77x1WwyGmI0HTRK+VP7LDOcj0uJkyEODhR3YOXc2BsSotmPnTm2hZHV5Igwaqy6TKiIyzxAIWItUR+VFDSUETdI/722OLrFGt3w9uu2HjuIeJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZnyOjvzTalhDsM3mFBfV4pUnXsek/CWUgCKYOpsAo8=;
 b=UVELDpyXksH56yTFgcHYkuF3t8HDhfORNRBjGIWSmcv+wqNqFZ5d73QmJ6vrnHN844oBoDCU/Z/mjZVnb11KAg4RRqxXW8G4TNzbNj1ClxSMMmdNu0zmSQ4hJS4y/cWNLq46h48Z1dE5Q/aUtNBKGGLZolXVFT2N/Hui5RjKoiI=
Authentication-Results: prevas.se; dkim=none (message not signed)
 header.d=none;prevas.se; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3570.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:144::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.21; Thu, 27 Aug
 2020 11:00:41 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3cfb:a3e6:dfc0:37ec]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3cfb:a3e6:dfc0:37ec%3]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 11:00:41 +0000
Subject: Re: powering off phys on 'ip link set down'
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Cc:     Lasse Klok Mikkelsen <Lasse.Klok@prevas.se>
References: <9e3c2b6e-b1f8-7e43-2561-30aa84d356c7@prevas.dk>
 <7a17486d-2fee-47cb-eddc-b000e8b6d332@gmail.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <4adfeeab-937a-b722-6dd8-84c8a3efb8ac@prevas.dk>
Date:   Thu, 27 Aug 2020 13:00:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <7a17486d-2fee-47cb-eddc-b000e8b6d332@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0104.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::45) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.11.132] (81.216.59.226) by AM0PR06CA0104.eurprd06.prod.outlook.com (2603:10a6:208:fa::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Thu, 27 Aug 2020 11:00:40 +0000
X-Originating-IP: [81.216.59.226]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a00fe933-6518-45ae-07aa-08d84a78701e
X-MS-TrafficTypeDiagnostic: AM0PR10MB3570:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB357040E71E754D1D24C7370F93550@AM0PR10MB3570.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e02vldKdpqdy4kFc53SZlTbKXz/Ez+BzVT93DYc/UE1HNxLYzzleR+QzlmC0ljErXK8M3lVGq8mO7SwMsNH7ORqgb08FcX89otHdvj26FFNmFwuYDRvXkX3IcGCjwkFXzDcYNY0b25qaUYdhJIFBpnCW6nlaokNwGzlVilrC7GiPT5LLEfitFpb6L78wGoitqXaXacqRG2k9K3BOId4OpaXiz5mYAPBU0RGe/n871+jJl01ciZpu7Pg089Gfk38D/jIXa06BqQOjEGj8pblD/5el0KWSpDluus3r+innxoCr/lrJw6WnOZc01S+fzARVh2dR6j6EDOxdIQqI30j2gd42b2lhkGQ/nvJdCohnwqTDU5D54v2ymyAgUS4nMxy9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(39850400004)(346002)(396003)(366004)(26005)(8936002)(6486002)(66946007)(66556008)(66476007)(44832011)(2616005)(956004)(110136005)(8676002)(316002)(16576012)(31686004)(16526019)(53546011)(52116002)(186003)(107886003)(8976002)(36756003)(478600001)(31696002)(5660300002)(4326008)(2906002)(83380400001)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gB1n5fyIcxyjdNa4j9JmwUnBzVAzaGb00kGwmtCTzE3cmTf4wHr2jwJitkjHQ5KjcbH+IrX20yVjjvypg2LGMJm8I69fsuaYGMjKswQyFBwTvR3tpRdOFuE4BS1qoAdG8Ay0J3kfof/1uDAqV8VvbGZYNINbBDBUlBl3Ao9p439FWmlW1FI9PnEYDCDHLn0/Xs3KTZdpq/X3tJeMBK5w9/onLsqVAMOzNkPoqlF0n9M8iKKPcahZSPPKbS9d00QgL27X9ZMtok/APeaFOHhjc42mIRRpyqprwoHXqqrpS8+/d7r49p4y7M4Wlbas/g4fFqtq4YKKmZmPEP31/Ch2BRsnKNvbI13Ut/bfGXQhYycLMsFArFaCYDxwOmWS3YzmufIxiyhDrSdrLXFa2xA3OjI1OJXSJzTwpmaMhCVg3zghjpRUBAK/OiFNK4+kCB2EbZhtrMYcoCXCdt1Fjjx3cZUZ/4CMBDpdxxUSbrKYfS7tqMupg/aUaDsO5dTNnm/EoyNbwetIvEdSeOOMw1eAmJvKQ0tfjG94tPu5sm1Rt8k71CxRm+3m4t83XqJBie5M/xhbKWUEit0weLGyXL8w0O1P3KnWYn6/NyqNzxk5i3QoC89Cfjt81rWCHa345e+YjAfR5x0UHgn42f+XuqotJg==
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: a00fe933-6518-45ae-07aa-08d84a78701e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2020 11:00:41.1381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mMWX4sR9EyDOENlkZrB6eG02MCIEA65fix142OdPXO++EWU0IOVXe5Z99nZfcmOyk4gSTX6elJp+9kouooHr7nmAJC3gHuqvqu76/K8Pr1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3570
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/08/2020 12.29, Heiner Kallweit wrote:
> On 27.08.2020 12:08, Rasmus Villemoes wrote:
>> Hi,
>>
>> We have a requirement that when an interface is taken down
>> administratively, the phy should be powered off. That also works when
>> the interface has link when the 'ip link set down ...' is run. But if
>> there's no cable plugged in, the phy stays powered on (as can be seen
>> both using phytool, and from the fact that a peer gets carrier once a
>> cable is later plugged in).
>>
>> Is this expected behaviour? Driver/device dependent? Can we do anything
>> to force the phy off?
>>
> This may be MAC/PHY-driver dependent. Which driver(s) do we talk about?

It's a Marvell 88e6250 switch (drivers/net/dsa/mv88e6xxx/).

> Also it may depend on whether Runtime PM is active for a PCI network
> device. In addition WoL should be disabled.

The datasheet does mention WoL, but it's either not hooked up in the
driver or at least default disabled, ethtool says

     Supports Wake-on: d
     Wake-on: d

Thanks,
Rasmus
