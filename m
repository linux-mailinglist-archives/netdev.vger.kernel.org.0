Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA1952F8D3
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 07:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345592AbiEUFIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 01:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238385AbiEUFIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 01:08:39 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF7F17997E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 22:08:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYZoXsxlILzzDGpjy3fgtymhxW24tYZOOfTH3CVQ86q322gwbEBtyTQn4DkDf/FXx+KpyGvgu2py9lfEVyUgS1+8zMxvlDuhY2UPjnepqJzDF4iCTPtd+6Xq3DlhVbbHUZpC3yHvLn3ihbOmm2mCCFeH70ord0nD/Y69J9VSt17cQbk/TSTVgOO/LvpgLHk020Km8O1YnLDrrxaSykKwN/clXsj6JLPQuI+BywhyLEN+aSVk/gmDgQgdTW1YgYEEh13denutUvbXDi9DJ+pu0S6bl7qx2NAGK2pNUXqDpHYngAsptsHMucnr3/IUtsAFiLxSEkSYPyW+yl3Z8RfJAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZGflh/XUoTmR/65yOZnH6kOf90+Qp/n+PZmgRP1I84=;
 b=FZJUd+CHRmwDuirxabivcO8IWTZXo1hi6mdtuzE3GPccxVvFe56JQhtNcxr8BshvnolyjrKxNlhZKMCL0O6FR6LMJA0lOKKHqIUL4lnlkKvy7bt1h6chj5bAXEl/QJ/TtPjMFnln2/u8HeZ4q7KTlGbM4fij0UlJoibw8R7UhArZDHANc/r9xFZ1MxAmxBpWiGdyo+/sMdeDpWgVV7h9P+/cGdgDAyQnKpxHOcT0LoG5kCWvfRmiJ8eH0uWHfnIoRZk95WWKAhW7C93t09ILopFgd+R0HPihPvYoa9i66JhTQPACjO5zwQsEc2hKrprHWfYIHdIsrNXp8+Aj4Q6N7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZGflh/XUoTmR/65yOZnH6kOf90+Qp/n+PZmgRP1I84=;
 b=KuoyGXVyO78WSIh82SeLHs3rzBukEZv5GyzUlNyXpYN68C7dfuWR5AvuQc8mEBfBZIKP+fZDXRT1bkFBli2m3Rj5GEZqiS/FlruU39w/QIYsl0hhGvM6dXTiq4RXiU0yYuk0jZI+/SNYZuKQXEj8Zz5bSIWGAZ7ChUZQCCSqb34bF3oZ5nwsyX3KGp+6ReGJcpkjXOLznxJyvDoX2ywcIvyQlCW3NJlIwK3VhLoS3VIJt2ASy45bpYSce2kLP6z9S0eK9+cYwYjMa0m/uwJ2b2xLLQHVy1MMcmkZ6IxvlGLzB3Dn+fiJ4CKAiugwJkkSIb28YhcKh50J5bdMNDyL9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MWHPR12MB1311.namprd12.prod.outlook.com (2603:10b6:300:13::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Sat, 21 May
 2022 05:08:36 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5273.019; Sat, 21 May 2022
 05:08:36 +0000
Date:   Fri, 20 May 2022 22:08:34 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux@armlinux.org.uk, olteanv@gmail.com, hkallweit1@gmail.com,
        f.fainelli@gmail.com, michael.chan@broadcom.com
Subject: Re: [RFC net-next] net: track locally triggered link loss
Message-ID: <20220521050834.legbzeumzgqwldqp@sx1>
References: <20220520004500.2250674-1-kuba@kernel.org>
 <YoeIj2Ew5MPvPcvA@lunn.ch>
 <20220520111407.2bce7cb3@kernel.org>
 <YofidJtb+kVtFr6L@lunn.ch>
 <20220520220832.kh4lndzy7hvyus6f@sx1>
 <20220520160319.15ed87b9@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220520160319.15ed87b9@kernel.org>
X-ClientProxiedBy: SJ0PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::11) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07d18e78-f6d3-4aff-be5e-08da3ae7f5c2
X-MS-TrafficTypeDiagnostic: MWHPR12MB1311:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB13117AD684E046DF77B3D5C8B3D29@MWHPR12MB1311.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c/qSQ4Q7UwNcz/IfrOE6Tl9AqKhfzWb4hJoEaBcYpW54IZFvTyhyQssZMCFm8hUHclESAsCpatkLhzZpKnX2PKAapOYfUqkUofdC+zPTws2SYlbkbuQYSEWqgedBiMFNPmk6oAy+tPb7dT9eJ+KxQjeZbIfWZtxVp8mSBUZuOHlFCvSskQG/ehPBFZWphxjU+Y9gUd+Smf+nIjDzXR4ZmKur2VysXOoJz8bNhAFJOwTtxu3/ZKycN0v2zpHwJ2BBSBPgOs84zmcqQol5j+pQ9uSqMT7YMi4N4tufK/3julVzPYzxDgTxTROSN7D0Oz5InC9LhpszvA/G/P+RuOi2B2OVwW7ZfzP2Z1S/ntswep8svUf6k778tjk8oYB3Mk4r1ywDmOrFiqF4VcmLVpTHaObOTmVJHm2IJhBNbjgovce76PrfLqjYOwZ8dNggymUJm4dJvrF5vLmkKAUPUjwmRXVbYrheS7R2FbIqx/cgCVPrCmjuai8hPx27sbSE5pHK7dsTDgdQZ29HzVfKFtF0XDLTx11yDWbFLQxA5ZJxDD+IK8Q5Sh6rI1+4nGzZFWGAy0KQv4BWQp70OTCLSzJV3YgPh5EL4TrQPnQIsQf2nc7NFV2X+/MI3jxhNS8RDojB39m4SAORqwwxrcqg9/D/xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(83380400001)(6916009)(8936002)(8676002)(66946007)(4326008)(3716004)(66556008)(66476007)(6506007)(38100700002)(33716001)(508600001)(6486002)(316002)(2906002)(86362001)(186003)(9686003)(6512007)(5660300002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4KUBy9NLmAzivBYs5GhZPFYS+CFt9d5v0ek+rWGEHNrUFxrPCSyAEcnSzq5q?=
 =?us-ascii?Q?P5BrmXV/ALTPrMjyVdL0bhx9KB7tdSlvOFJVDrbcteVzgSdIZ42M2SQ6LJkK?=
 =?us-ascii?Q?9zckHyAvNIq9NbIlLhiZ2BJUj3KAvBYyCUEdGNm0Cpq23+Q1ZMaL+vSYMPSu?=
 =?us-ascii?Q?b2Js9joS5ueBZwda9V5s/6pQOTyl74zvjNB2WO0u0kO5YOTaNTOiwsWT5vgd?=
 =?us-ascii?Q?TlOi7nOntYvkkvTEb+0/uU7x5t0eHj4zoSYuCPoc6LI4qKlxDLRsZm93IHs5?=
 =?us-ascii?Q?39qg7SEd1xstm6yqvnqsDZ8b/amMiTDPvdcxXiPS3HUH75TgSqZvimPsBKGi?=
 =?us-ascii?Q?3WqFRMJAGi50q+7L2nEP9YL5/yUq7prMWYyi8LFnP6P9/xFWvSfewEi05UmL?=
 =?us-ascii?Q?/Xx5OehvjvcQLhYDvOQQq+v9dEFGTZ066P/u2dgtqsuc1/MMTwspbwx4myXM?=
 =?us-ascii?Q?5awx8lnIKAwkpLBI+JOp4iT8LJktzQlPWBsrrh6gPpAoxHUCalPQqIZacTkv?=
 =?us-ascii?Q?fI0JHNDH0fj8G+YVMtzifE7HE+9zBZoYolsJFAUiZtLvTMbU932wnAN/uCBW?=
 =?us-ascii?Q?DVGgo8ordDBcmIDDKo46Qr7kntzUrebb1L7tr680XuV3V3iaE+eEbjRVmSg8?=
 =?us-ascii?Q?7ZvCw3FEIQ6SDlWUwTvvuKTgHJMe8eVSaoXHHoGY9fUYADJKXvEVEIhhVhCZ?=
 =?us-ascii?Q?tINmQE9ruJoHMtKAkDps4YwSwD+gn3ha8ksAk4AvMZ2T90lZ9we4I7B5Av2B?=
 =?us-ascii?Q?NlHwgt3kyoYp1Z7KEQSO2Fb6BgvkakaAgjhQrbIhZtHvF+9IrssYzrV8C6fZ?=
 =?us-ascii?Q?x+4x4LaO3T74bEusccRLkAYLcssn78cevBfdy9hnotFLLP32sushinfjqVJH?=
 =?us-ascii?Q?0nbW4Tb84Nzcqg+fcKOJjsquom85CN+fSZxo1+OoB5dQJO4chJTuT0fK1AZS?=
 =?us-ascii?Q?dje5Xqmq4qHaGOiWRTVNRe9kZjKNZ9FSMxXpsBfVgjts3yHPUxdSulorRqOf?=
 =?us-ascii?Q?6V7srw2oSB9+BFqyyscl9PhAO4evQfXXfJklyODrSlh+c3Ii3bpVGII0FK5a?=
 =?us-ascii?Q?ZMEqFD5JrI3cTU9Qt+hrlYBkMckneNSaXXwhljam3EB3oLjAclsUglLsM6iW?=
 =?us-ascii?Q?iSj8YtrVaW4Vn/nQC7lhdSyefuSqKYw3F0utA2yqsM1ypCtRr7BHKDJeztad?=
 =?us-ascii?Q?QS9iPI896XYL2uP3qKrBpRFaSTJ5Moxq25qsBNWWbVebvuL19XE7zd4DB4vI?=
 =?us-ascii?Q?4ILQhSB6NqL5R4qO2CF0WpywM8bT+aUfiHrhgI8aYLcie+TlCFRnRXrU+QQq?=
 =?us-ascii?Q?8gf6Z36W4AUTpFzdvy+YMsefJ5e2BLMF9MLyEL9Az54py1wrgdGzI8kJfoR6?=
 =?us-ascii?Q?7qcvvQo1+yXxVtZKnnG5dqy2DQl6kXs7neExwfArp6RS+Pr+ZKe/6lyXCRYf?=
 =?us-ascii?Q?zLib2zEl7Wxd9yEwZzGJARo+a8V2aVkIurq//Hopw+c2OmxJ61ygGO/IeiPn?=
 =?us-ascii?Q?m8axD46YhfKHBFFDAEmxZaiiSt0WkzIuVUQ+6+r1U/AvDMy7mMmXQuBDjgaF?=
 =?us-ascii?Q?bci50nogUuOIDuFEJ9oqs+viCNwYW+WzIEMy4ozqnEX8/mqw/chvIyjPNUGx?=
 =?us-ascii?Q?VltHBQgdFpVHDmQQjiF5x8gi/wpbxSKkrpff/5+uR56rZjTi4ZSYHBnmnQub?=
 =?us-ascii?Q?0b5yZkGXsi2PWy7lxddFYtg3n6nDA7SoHO6EKioynd1PzDPdAWKW2PjR3VNn?=
 =?us-ascii?Q?5jZV9GK+sSTmmWXkcWMiCHNHY6/mfiU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07d18e78-f6d3-4aff-be5e-08da3ae7f5c2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 05:08:36.3102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6U6w8UxxtdZRc8/+MNSTuCdDHquN55OOYdwzeoZyOjYta+bGpT8r3c1sk7P7AgZ0+aOeCBbbmeQIngMm7DrOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1311
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20 May 16:03, Jakub Kicinski wrote:
>On Fri, 20 May 2022 15:08:32 -0700 Saeed Mahameed wrote:
>> >I'm not sure this is a good example. If the PHY is doing an autoneg,
>> >the link really is down for around a second. The link peer will also
>> >so the link go down and come back up. So this seems like a legitimate
>> >time to set the carrier off and then back on again.
>> >
>> +1
>>
>> also looks very racy, what happens if a real phy link event happens in
>> between carrier_change_start() and carrier_change_end() ?
>
>But physical world is racy. What if the link flaps twice while the IRQs
>are masked? There will always be cases where we miss or miscount events.
>

this is why we have EQs in modern hw .. but i get your point, in the driver
we care only about the final link state, we don't care about how many and which
events took to get there.

>> I think you shouldn't treat configuration flows where the driver actually
>> toggles the phy link as a special case, they should be counted as a real
>> link flap.. because they are.
>
>That's not the direction of the patch at all - I'm counting locally
>generated events, I don't care as much if the link went down or not.
>
>I believe that creating a system which would at scale try to correlate
>events between peers is impractical.
>
>> It's impossible from the driver level to know if a FW link event is
>> due to configuration causes or external forces !
>
>You mean because FW or another entity (other than local host) asked for
>the link to be reset? How is that different from switch taking it down?
>Either way the host has lost link due to a non-local event. (3a) or (3b)
>

I was talking about (1) vs (2), how do you know when the IRQ/FW event
arrives what caused it ?  Maybe I just don't understand how you plan to use the
new API when re-config brings link down. 

for example: 
driver_reconfig() {
    maybe_close_rings();
    exec_fw_command(); //link will flap, events are triggered asynchronously.
    maybe_open_rings();
}

how do you wrap this with netif_carrier_change_start/end() when the link
events are async ? 

>> the new 3 APIs are going to be a heavy burden on drivers to maintain. if
>> you agree with the above and treat all phy link events as one, then we end
>> up with one new API drivers has to maintain "net_if_carrier_admin_off()"
>> which is manageable.
>
>I really don't think it's that hard...
>
>> But what about SW netdevices, should all of them change to use the "admin"
>> version ?
>
>The new statistic is an opt-in (via netdev->has_carrier_down_local)
>I think the same rules as to real devices should apply to SW devices
>but I don't intend to implement the changes for any.
>

it's and opt-in with obligation to implement it right.

>> We should keep current carrier logic as is and add new state/counter
>> to count real phy link state.
>>
>> netif_phy_link_down(netdev) {
>>     set_bit(__LINK_STATE_NOPHYLINK, &dev->state);
>>     atomic_inc(netdev->phy_link_down);
>>     netif_carrier_off(ndetdev);
>> }
>>
>> netif_phy_link_up(netdev) {...}
>>
>> such API should be maintained by real HW device drivers.
>
>"phy_link_down" has a ring of "API v2 this time we'll get it right".
>

c'mon .. same goes for netif_carrier_local_changes_start/end and
netif_carrier_admin_off().

>Does this differentiate between locally vs non-locally generated events?
>

no

>PTAL at the categorization in the commit message. There are three
>classes of events, we need three counters. local vs non-local and
>link went down vs flow was paused by SW are independent and overlapping.
>Doesn't matter what the counters are called, translating between them
>is basic math.

Ok if you want to go with this I am fine, just let's not add more peppered
confusing single purpose API calls into drivers to get some counters right,
let's implement one multi-purpose infrastructure and use it where it's needed.
It appears that all you need is for the driver to notify the stack when it's
going down for a re-config and when it comes back up, thus put all the
interesting heavy lifting logic in the stack, e.g link event classification,
freezing/flushing TX queues, flushing offloaded resources (VXALN, TLS, IPSec),
etc .. 
currently all of the above are and will be duplicated in every driver, when
all you need is a generic hint from the driver.
  
    



