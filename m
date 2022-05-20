Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE73252F57D
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353799AbiETWIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353796AbiETWIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:08:37 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2058.outbound.protection.outlook.com [40.107.101.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5537D195919
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 15:08:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEtnO0iN/GWtB0IsL218l+vXCVOuOn1HPRaWFRoyWhB2fN9uQoe9tup7Qpzluxjhq05IwCCidHfAm63L6rhnS3Xw38m0gTtBauNlfhFmavjYaHo7UoGfV+f+ZRSO6lQ3ZLE2fvZrOAOBc9ZrG3SWAgCxY7eKLvXqr48HpfxLXq6ip1fZTd0wVdjyYWnF7PwFpT7KbS5jXcEi0aXvcHjZnW8SLXYEIkV4Uc7xaIBWG2fxx0YbgAu6XiwO32UMHxMEonk2cOp4se6X9meHy7oG14MEU6KkdxF1whweeXrw5COX1LucqkQ3wmBpH4nteTXU9EIjFK+lm5hiFnx2Cci9yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j53hCfblF8LnHLo0BkNR9Irm/9I8SaH3HFSBAz6+czI=;
 b=ZMbSy9kC0zKUNeOoFRFJzz9JEs4onsJV0ooF/rA+8SWxptZUR1c9dqpjV+WAbODMglF+g8YGp2Nada2AHFI+vivC8ycka/BJgveTHoytYWwgimdVhJx/Z9/fBSoFcjuRxYClIxqUD80RMXdi5k1QpP7DBvhNksgfR+U355xfzSbldJ4ggxHAFgZa3lHW4AVu1j96F0AjNLlfUjxJ9Sjhw3HNuKBtU3rZF++enzZmlDBkJ44jMVENNE0kZjT/AgICXzME9s5JxHbTz7BFeGwhJtLeC2kD/Z/DME05vHp/GaZrSVmxi6xCT2lsKYfTgI4w/pSzToOgWMadHSc0zvch4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j53hCfblF8LnHLo0BkNR9Irm/9I8SaH3HFSBAz6+czI=;
 b=IWQbzuxDeH0yhOQ/PdcwBYtDU9j2OnLLGoGaeVxt8VMc91NSHANb19HH61X4n6wmtqmC2vOODHxS2cuSGhAoavNWhfHEEOGToEKFdapsSaBo/uuL9GgMfllrANfzxycQT3/D7ok5Dated4uesx+/ls6Qj5DJyhfxJBgw3/Au59SWupJnk254Y/7O6B6qDAlA+Oz7Ce/bQ957tY7fs8Qw3b18s0jcFO4KRBcJ+PMtOi4+U+2Nirz6pAMvoeBw2M+TXWYUJociNRr148YG1krNMblBfSA03ROY+grfCw6qVpVGf7Bh2G0/u0kJbDZVLGfS5SQ79V4ILj86RXvopB7p0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CH2PR12MB5003.namprd12.prod.outlook.com (2603:10b6:610:68::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Fri, 20 May
 2022 22:08:33 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5273.015; Fri, 20 May 2022
 22:08:32 +0000
Date:   Fri, 20 May 2022 15:08:32 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux@armlinux.org.uk, olteanv@gmail.com, hkallweit1@gmail.com,
        f.fainelli@gmail.com, michael.chan@broadcom.com
Subject: Re: [RFC net-next] net: track locally triggered link loss
Message-ID: <20220520220832.kh4lndzy7hvyus6f@sx1>
References: <20220520004500.2250674-1-kuba@kernel.org>
 <YoeIj2Ew5MPvPcvA@lunn.ch>
 <20220520111407.2bce7cb3@kernel.org>
 <YofidJtb+kVtFr6L@lunn.ch>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YofidJtb+kVtFr6L@lunn.ch>
X-ClientProxiedBy: BYAPR07CA0085.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::26) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73a8c5ea-33b7-404c-1dc6-08da3aad4763
X-MS-TrafficTypeDiagnostic: CH2PR12MB5003:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB50032B93472E4B30F0234500B3D39@CH2PR12MB5003.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9CEfLF2a/iHFXV5tKr5ZS2d23Znbd4iDXznZzwGuOyFg1eUmPRHZzmPfoZQICc6EhsAXGRs+KKU+6j3Vo6QOeVaevU/blwPiSdqBz7qQuVTbgOO8uXJjnR7WnMt5cvkMb3xv2/W4wNjxht6KKWKmu9hzmSlGkQijsrJGAicWWbjGUm4ecNd5d62R4o+lwyUr53ZmPfxK80jExTX+jH1OwC+pTJJ15fHTDLITK2dyRTkV1BoIEmrDgiQVbyRh5pafo+G53qciZfekL1jGjclOd6iRzVi4cYR+p4RoXq2xbHnfcVQqlu1CI7EysrJE6d4/0qHTr9KnEZB9NXQdvs49WL8JNyzSGZXj1bb3eSV68QraRMLm3x1h5vd2SmAdokuSwSW6UlS34tiMyRFmlyrPy0NsJfx+arCn82PugeWLnFbxCtScWLZe5j9rZZ9hFKiir6oLcNXc+gm7UyHgZWKuDJi6mu7SMINeS5EaHLZ9BbAGtbxvCYTEVSkzVMrlNGvQ6mE3hoAtm97I4bLPXG4OgPHAryuZViC7aLenHAjPLY8FH5xj8CnDEa1IC5uS+PshB1kL8pqplia8gfa/999BHEvVH1ExzRBLUF0xzYMotEs1YKKCnV5hwCnnwQYbPTFMg220lNjvGNmA56J979GWwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6916009)(1076003)(6486002)(508600001)(4326008)(83380400001)(6506007)(8676002)(9686003)(186003)(316002)(6512007)(33716001)(66476007)(66556008)(66946007)(8936002)(38100700002)(2906002)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e3ZKK+lj9j9NC7nCj5boSL9oNb5zq4F5JxjiD4MKTK+ivLVie6JmmeI4L5j7?=
 =?us-ascii?Q?tVgsbuwoFONAQyExCSMyO0MY+PjeI3zOioiVwNVs6PeQ8Lnts3OKlzkchYKy?=
 =?us-ascii?Q?oWZlBCVqH2AdrFx5kitGHhaTxANCp+8ZumwDJT8FkMcSFatG5dQCbh3iICEe?=
 =?us-ascii?Q?dEtwt6Oa4xdtbMy907i1DXcmdA7pwv5E5GW7TRGcNtxen6qPn1Bu1tFHzA/t?=
 =?us-ascii?Q?8S6Xpbmm38CoHL3Y4bWgZdOs8vmOnuU7LasBU8U7/Yq4CRchJK4ntrHidLRj?=
 =?us-ascii?Q?bU7wYgFSoPs2yavogLZLi/OlLkCawEa6waV6Pk4TeclIUMkq8bDfUbySV4Nd?=
 =?us-ascii?Q?NYnsu2ewCQvmFv/LhW8lrL7xClB1B0R8/X5DpoP5f5DPewH7Xgl01n7E7Kh+?=
 =?us-ascii?Q?2gyABAQ95CwFMe+UXrHLBpcVoPaITM9pdkBDUX24jMjwJy68w3QS33b5fHYn?=
 =?us-ascii?Q?txsIe+KlFe/w3E9LIqJHOsQkRLY5yxzK+t8pZbGVrdIBmkAOZw99rUjYyB5Z?=
 =?us-ascii?Q?QcOHeHrfC7b0WU3fOKY5jA7497L5CsO/Kq66xMf3efz/gaSVQvkkxBcHjRU7?=
 =?us-ascii?Q?vnbZ5x3WPAAyAhniEWQPwJmKzMf35BYjf/1SBGVGJltdP/1SnJMhSwiFQ7/O?=
 =?us-ascii?Q?x50dVufOLWY32gWfURzPStLLEtTgdc4unLKBWC03fV1IzBToQ4Hww/CMnX/Y?=
 =?us-ascii?Q?a63O+Be5OGIPxaBpLcalwF4gniXZhgRCby6GOAMithtavoDXyDYaVHZPF14I?=
 =?us-ascii?Q?RTMDYY+kO8PRZyK6mZmvrtay4ZxDXH56K7bc8dVBuy2CPhGv9zZ0sNH8NbNl?=
 =?us-ascii?Q?UCZMXC3L4rgCOKvMegs7cQ9jcKfAy1XIodGb3CEN2kfnMZ752o17ef5/O80c?=
 =?us-ascii?Q?upubGdFyBpP6IAlvmuvYW9TZ2+KicdN3LdqTgEJoMWBt4VP3CmtA36Kn5Pan?=
 =?us-ascii?Q?Pt/lVe2hzjqLBcWIhg1/Luwvb4xMnsoVKN69y/wW+h1Zfk+w8+/EWT6TS1Nd?=
 =?us-ascii?Q?44dCTVpFP0NM1wpuNFjIO7Jxb70ayh+lLdpE0+1beppD2EGnbfuABXDXCNRJ?=
 =?us-ascii?Q?wGqEm3V/YtoTIXq7IW9qOWNxxhW+e30/YPYKrexa7F4udErFb+1d1tkDQAzF?=
 =?us-ascii?Q?1ZJ7LcVd5Zo9wU8Pfn1B9kBho6Gdm3SS5qEWmyk2RJvW/MzTFE1F86lyehua?=
 =?us-ascii?Q?/I/mAr3GYjKczg4GzQPUnEA8krd+tgIyDo/a4s+N4frJ9CiwiqhiEVqMIqXC?=
 =?us-ascii?Q?y1jD5RHiRKo0oJhpQEJ4GJLfl0IAU3IvF0DOkGfii4bzBMlckunt7RfHNoUa?=
 =?us-ascii?Q?WHs6mxx9wHe7HLI1jR4Wng54yzJQQL7n6ikA3NQzzsn1IW2R1b/MCUNW6w92?=
 =?us-ascii?Q?3kOehH/WDwzb6JJ4VGEru2leJ0PApwkb7k4RETberMadw4Qo/iEubaNxiNyp?=
 =?us-ascii?Q?gNrfSkAZms+Pum1kmQ4kr9qsTlvAKFob19p9cWYJCNJE/egavsF5t82nBqWX?=
 =?us-ascii?Q?8ungSD/9fq5Bd278ZDMy7kp4hi9o4FwcUNrhB6UXb9jVdwvnVmsNe9Mvhn+v?=
 =?us-ascii?Q?pZ5EouQOIEqUSG7Xpps3lcrPavSg0XKxmMKpysxhTYXneuyMbZuk12JTl3/y?=
 =?us-ascii?Q?aPZ8KWRMl2mRPEnYL2NZQ3AjjqF2t/3RT0wjmRkbDsfH3w+RpiTmQexhkZ9l?=
 =?us-ascii?Q?ss2ZUspr3TtMBH9m4choDon7eA6/rrgOQsWd/kILcKd/fbiZ8ceXYxp4UgSS?=
 =?us-ascii?Q?tR7I9uUazzi/sLWEWIZ1xxYMIUD1Auw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a8c5ea-33b7-404c-1dc6-08da3aad4763
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 22:08:32.9520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XUXHJOeCkzXgfriyriBg38uR/9gwCoCc0Oqx+i/vGtHu6jEcJZEtDCjQ6E2AKIao2hx4NzqUp3Udq0XD3Vhi2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5003
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20 May 20:48, Andrew Lunn wrote:
>> I was looking at bnxt because it's relatively standard for DC NICs and
>> doesn't have 10M lines of code.. then again I could be misinterpreting
>> the code, I haven't tested this theory:
>>
>> In bnxt_set_pauseparam() for example the driver will send a request to
>> the FW which will result in the link coming down and back up with
>> different settings (e.g. when pause autoneg was changed). Since the
>> driver doesn't call netif_carrier_off() explicitly as part of sending
>> the FW message but the link down gets reported thru the usual interrupt
>> (as if someone yanked the cable out) - we need to wrap the FW call with
>> the __LINK_STATE_NOCARRIER_LOCAL
>
>I'm not sure this is a good example. If the PHY is doing an autoneg,
>the link really is down for around a second. The link peer will also
>so the link go down and come back up. So this seems like a legitimate
>time to set the carrier off and then back on again.
>
+1

also looks very racy, what happens if a real phy link event happens in
between carrier_change_start() and carrier_change_end() ?

I think you shouldn't treat configuration flows where the driver actually
toggles the phy link as a special case, they should be counted as a real
link flap.. because they are.

It's impossible from the driver level to know if a FW link event is
due to configuration causes or external forces !

the new 3 APIs are going to be a heavy burden on drivers to maintain. if
you agree with the above and treat all phy link events as one, then we end
up with one new API drivers has to maintain "net_if_carrier_admin_off()"
which is manageable.

But what about SW netdevices, should all of them change to use the "admin"
version ?   

We should keep current carrier logic as is and add new state/counter
to count real phy link state.

netif_phy_link_down(netdev) {
    set_bit(__LINK_STATE_NOPHYLINK, &dev->state);
    atomic_inc(netdev->phy_link_down);
    netif_carrier_off(ndetdev);
}

netif_phy_link_up(netdev) {...}

such API should be maintained by real HW device drivers. 

>> > The driver has a few netif_carrier_off() calls changed to
>> > netif_carrier_admin_off(). It is then unclear looking at the code
>> > which of the calls to netif_carrier_on() match the off.
>>
>> Right, for bnxt again the carrier_off in bnxt_tx_disable() would become
>> an admin_carrier_off, since it's basically part of closing the netdev.
>
>> > Maybe include a driver which makes use of phylib, which should be
>> > doing control of the carrier based on the actual link status.
>>
>> For phylib I was thinking of modifying phy_stop()... but I can't
>> grep out where carrier_off gets called. I'll take a closer look.
>
>If the driver is calling phy_stop() the link will go down. So again, i
>would say setting the carrier off is correct. If the driver calls
>phy_start() an auto neg is likely to happen and 1 second later the
>link will come up.
>
>Maybe i'm not understanding what you are trying to count here. If the
>MAC driver needs to stop the MAC in order to reallocate buffers with
>different MTU, or more rings etc, then i can understand not wanting to
>count that as a carrier off, because the carrier does not actually go
>off. But if it is in fact marking the carrier off, it sounds like a
>MAC driver bug, or a firmware bug.
>
>    Andrew
