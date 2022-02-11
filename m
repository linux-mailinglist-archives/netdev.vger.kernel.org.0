Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4794B2097
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 09:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbiBKIuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 03:50:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbiBKIut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 03:50:49 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2040.outbound.protection.outlook.com [40.107.96.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268CEE67
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 00:50:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dShvyQlITszkdL8BOh/7TfVrQO38wt9Y4k74rY1NmCY/WcmIsMkcNkZOHh2AMWNdvbztS1KeLmYAcmar2jl/S4/sXH11u/6FXOwXl8NuPTwUlpRXK96wfHRAfLb7V7ixIr28gWQZVPGVdF2eDd7RtN3CIrhGWW+DYWE/sU0CJCOUzrK7PuFV8a1YY2PSnliVLkMt2ADvcJ362Gics+9XDyxIlQaNE/7Gy45MV5Lkm37gB4FRFBi/AixKjX4hEKn6Ua1/SXdra/tC3//kiPia7mdF/q452jXWkpURdlFTpVmrLUKhRlaoPJfT0PeQoOci003mrC4FrFNZ1k3aTdNdwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fittvBOLgXGD/eNA2i9ePnZzm0Pxj6KW41R+ROl7tLQ=;
 b=hMKQYTjITTneNLtCqNuULYmIvaxos0a4rMDRVMKolsR2vLceEScph4S3GR7oJGYeHLnmz/OSlLeIzQRKGRGGixZDhphJHJFA8WJ3TBKmfxalDLiDR8ymWgPysx2Tf8+xTH1PgGPZEKRlxDAl8aHPcfTJrg7XQIVdHsLgOFoC2S08I0d3BHxXhGALsbcE9kivsyrXcRD4SsDrs9mr7nVaZSTabga8of+RLoBDXRoo+yGVTvfyvxzchPRHOGQyzQPRoc408LHj9GncnPmJvcsyF93RzhuaUfr5Cvxt6W+CMt+KwF485K9YPuyujtI1/ZwSWE6/q66In/PdD+SAoP2ojA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fittvBOLgXGD/eNA2i9ePnZzm0Pxj6KW41R+ROl7tLQ=;
 b=MS5Tu1Rx/5nlBeKZRSrgVP+pjVPKliGQsSlnwMy4WjsfgOg/dwOy3MMQEuL/Tlxth5j9qOAaH/w36dO2cm8RTH4MPwILoNYWbJNr1aRfW+Vokw6l1CnJX81ToSc9sEPtOu3hKNp08UtH4hAiSTgTZWWVYN1w8k1hOj+Vh1C9bLu3AUEmzOBXkGHC3ZOTXxqkm5wKqtuGO4GdP15KmtU6n+N3oK9ElOed8RBJyh9H5q18DYWWY6u7X9Ku9w3hsYE5Yvh8xCCiinpuYdFA1NNFcIm9QxkFfVQfNy6r3Iql76VG0gaaRQEKCWK7JU/oA9vfoT16/xPwuek+REqPG5Cklw==
Received: from MW4P220CA0006.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::11)
 by DM4PR12MB5842.namprd12.prod.outlook.com (2603:10b6:8:65::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Fri, 11 Feb
 2022 08:50:47 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::e0) by MW4P220CA0006.outlook.office365.com
 (2603:10b6:303:115::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Fri, 11 Feb 2022 08:50:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Fri, 11 Feb 2022 08:50:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 11 Feb
 2022 08:50:46 +0000
Received: from [172.27.1.47] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 11 Feb 2022
 00:50:44 -0800
Message-ID: <0b4318af-4c12-bd5a-ae32-165c70af65b2@nvidia.com>
Date:   Fri, 11 Feb 2022 10:50:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC 2/2] net: bridge: add a software fast-path implementation
Content-Language: en-US
To:     Felix Fietkau <nbd@nbd.name>, <netdev@vger.kernel.org>
References: <20220210142401.4912-1-nbd@nbd.name>
 <20220210142401.4912-2-nbd@nbd.name>
 <bc499a39-64b9-ceb4-f36f-21dd74d6272d@nvidia.com>
 <e8f1e8f5-8417-84a8-61c3-793fa7803ac6@nbd.name>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <e8f1e8f5-8417-84a8-61c3-793fa7803ac6@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 179fb790-8445-4f29-2826-08d9ed3b98df
X-MS-TrafficTypeDiagnostic: DM4PR12MB5842:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5842F6C48267A0BB04C7EFC1DF309@DM4PR12MB5842.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mKz0LNILWD4tnCWQThR3vXyCWlT1TKwjvrUncRrmr8UDPsXGChGwubt6B4UZbV/Ws80/4RVrPVtaU/XDSp0KRdzyHbrmeRUEU9Xd77EgDkk67D9KLTUkGi4C1//MdEwdmgQLNtS7BBFkY8jKUaI8n+7XSVb36oe+gSLOv2mKhGqFA9H2X7Q+Xz8o6xYcA49r6SLRxP8d6Uet44xuMgw0XLvIMCTa80q7BMU4q0Jq/prebE5iIbxHKpoZIKR8I0io050qJCZuNbxn8pjNsV7Rm2R1fMyvqBdjdj0OmEKHWKKHqm5BnJ0RKmp7sqpC4P+VdbbRvEWurTahVgcuyf5sBpTP8gE9DWo8Ay23GyyBDxNu4kxOaiGG+knhx1xZr36buc8M5l49zN1fu5h2GKXOL0I7azQdQuJUt6Kwwi63aAS+sc4MJQct7+zUifpihpjuvmnSu4rF7XM/pyO+DMwiy/lNf4Yy1vp8r5enbIFxkmbEDS+yc7Qe/WMx6oq9mpaDswvamUIk4k3o9ZZTMuODOjpSCdkQBl6j3bzE1b48eUulUjrAIo3Dv9+BilssSBqN9obR6NC1Dx1zOu5XQxZ6zp0kO3yTSCJdD2X4wnAHQO6ZDGu8fFLQ3nYusRL7m2NobGKzynmNOfmq9sg8Q5iUb3Aofntkz9MDjWAs9bPLDC4qAb7JcvLlQx0Fij+9xpyeGhEIrUcue/dyYlWJma2akwPTbgSyofSzfAS/USILvIuryc9CuD/w/pwoalwzjbaqxoQsMQyeS/M1fldQ7ZNauA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(47076005)(83380400001)(82310400004)(36860700001)(8676002)(81166007)(356005)(8936002)(5660300002)(336012)(40460700003)(31686004)(316002)(16576012)(70206006)(186003)(70586007)(86362001)(16526019)(426003)(508600001)(2616005)(2906002)(26005)(6666004)(53546011)(110136005)(31696002)(36756003)(2101003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 08:50:47.2313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 179fb790-8445-4f29-2826-08d9ed3b98df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5842
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/02/2022 18:53, Felix Fietkau wrote:
> 
> On 10.02.22 16:02, Nikolay Aleksandrov wrote:
>> Hi Felix,
>> that looks kind of familiar. :) I've been thinking about a similar optimization for
>> quite some time and generally love the idea, but I thought we'd allow this to be
>> implemented via eBPF flow speedup with some bridge helpers. There's also a lot of low
>> hanging fruit about optimizations in bridge's fast-path.
>>
>> Also from your commit message it seems you don't need to store this in the bridge at
>> all but can use the notifications that others currently use and program these flows
>> in the interested driver. I think it'd be better to do the software flow cache via
>> ebpf, and do the hardware offload in the specific driver.
> To be honest, I have no idea how to handle this in a clean way in the driver, because this offloading path crosses several driver/subsystem boundaries.
> 
> Right now we have support for a packet processing engine (PPE) in the MT7622 SoC, which can handle offloading IPv4 NAT/routing and IPv6 routing.
> The hardware can also handle forwarding of src-mac/destination-mac tuples, but that is currently unused because it's not needed for ethernet-only forwarding.
> 
> When adding WLAN to the mix, it gets more complex. The PPE has an output port that connects to a special block called Wireless Ethernet Dispatch, which can be configured to intercept DMA between the WLAN driver (mt76) and a PCIe device with MT7615 or MT7915 in order to inject extra packets.
> 
> I already have working NAT/routing offload support for this, which I will post soon. In order to figure out the path to WLAN, the offloading code calls the .ndo_fill_forward_path op, which mac80211 supports.
> This allows the mt76 driver to fill in required metadata which gets stored in the PPE flowtable.
> > On MT7622, traffic can only flow from ethernet to WLAN in this manner, on newer SoCs, offloading can work in the other direction as well.
> 

That's really not a bridge problem and not an argument to add so much new infrastructure
which we should later maintain and fix. I'd prefer all that complexity to be kept where
it is needed. Especially for something that (minus the offload/hw support) can already be
done much more efficiently by using existing tools (flow marking/matching and offloading
using xdp/ebpf).

> So when looking at fdb entries and flows between them, the ethernet driver will have to figure out:
> - which port number to use in the DSA tag on the ethernet side
> - which VLAN to use on the ethernet side, with the extra gotcha that ingress traffic will be tagged, but egress won't
> - which entries sit behind mac80211 vifs that support offloading through WED.
> I would also need to add a way to push the notifications through DSA to the ethernet driver, because there is a switch inbetween that is not involved in the offloading path (PPE handles DSA tagging/untagging).
> 

Add the absolute minimum infrastructure (if any at all) on the bridge side to achieve it.
As I mentioned above caching flows can already be achieved by using ebpf with some
extra care and maybe help from user-space. We don't need to maintain such new complex and
very fragile infrastructure. The new "fast" path is far from ideal, you've taken care
of a few cases only, there are many more that can and should affect it, in addition any new
features which get added will have to consider it. It will be a big headache to get correct in
the first place and to maintain in the future, while at the same time we can already do
it through ebpf and we can even make it easily available if new ebpf helpers are accepted.
I don't see any value in adding this to the bridge, a flow cache done through xdp would
be much faster for the software case.

> By the way, all of this is needed for offloading a fairly standard configuration on these devices, so not just for weird exotic settings.
> 
> If I let the bridge code tracks flows, I can easily handle this by using the same kind of infrastructure that netfilter flowtable uses. If I push this to the driver, it becomes a lot more complex and messy, in my opinion...
> > - Felix

I've seen these arguments many times over, it'll be easier to do device-specific
(unrelated to bridge in most cases) feature Y in the bridge so let's stick it there even
though it doesn't fit the bridge model and similar functionality can already be
achieved by re-using existing tools.
I'm sure there are many ways to achieve that flow tracking, you can think about a netfilter
solution to get these flows (maybe through some nftables/ebtables rules), you can think about
marking the flows at ingress and picking them up at egress, surely there are many more
solutions for your device to track the flows that go through the bridge and offload them.

Thanks,
 Nik



