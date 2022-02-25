Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942E64C4D1D
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 19:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiBYSAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 13:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiBYSAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 13:00:38 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D157F2510EA
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 10:00:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bn7/HSRTmu2TaeyftYqCqqjSWOL8XPrWoGs0DQa1XwG/xWXinYs0WKJig2PnaB1O+by4baPE+d/BBI6cQNHukPYrHZhPC4cE+wuCBfxDBOMNMsuP7n6nlhhvwdxOFOzjxEQz9+MkMy5dUJtyDmN5kEzAgH3iQSnBFOmsjemCvgRmlOWkPXVIwRhUU38RqdOw6kL+D6Y7Iac0cYJ85fd89Z8U1WSszZKNFho5MVNzognuvUC4lWUnMBDMbrN+WDkU5OHlDhlcNuufpa4h0/jfWBykc3Cppyc+OmuWQYATJK97mGpizKdqgI0WSL6qFixC7j5vT/SNMtXZZHluXCEIxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4jAbwh4x3zOH2KCwJdzrCGQZKWpODodhH+XQcLfSSI=;
 b=M37ei2tYda6T2gk/mMTZp/qJaKUk3zihAsiBuL7uW978+wy95+dzzvG+A0oyCOxk4bEeAcbkxaySOiFhgt/LksDV7rGG25OLgReNwBYAn8PmdGma2iOq3WiQfEfSRJrOq4/al5qVVjk+B3u44pAq2v33hURz33jVLbxR2pawHpbtttnfN6FvtL5SFmWKnlgKqqWkCOH+/AgltcqwelObHKjfmfF3AuIrVdJLd+3TxCFelCMUG4SqwS5zvZmqp8A9ZvEzlqslajCNBhIWJKFbKGYlnzTT9CmuFK0gr/sMrJsl3FQFxyb6oH4A5HigWptNIEGIVQ5XmOCXr3dizJscFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4jAbwh4x3zOH2KCwJdzrCGQZKWpODodhH+XQcLfSSI=;
 b=lv5C4AX7ecqo8jwOsOql3xinpe95RJDvaQ31BsF4FbJ2XzIJcC0DbgdRVO3rhgdz+QP3JxB0psfxg9d5OtCf4blg81I0CXU9Oc2rdpkdQJgx3UOFXmajQ7tlGrCV1OUN4bvI+8amgVjLPpsSfryDumS4TJWc1Kmhe+ig/4ZZAvO9r9/Z+qcBreVIMk1CkMkN9vtvW4u0b4/ARO33j1k88cZ2BVmBeHHYyWT0Re43J0LTogL7zzvqwLrYWUtfgJbbxr9i6JoB/s9QJbB3n/aDl7/EcFx9Qoh8l5XqeN/7fSgj9TQGJqnPBwlqX3IyYpJdl1zXiiTAE53cHUsqlzQPwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by BN6PR1201MB2464.namprd12.prod.outlook.com (2603:10b6:404:ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 18:00:03 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6%7]) with mapi id 15.20.5017.026; Fri, 25 Feb 2022
 18:00:03 +0000
Message-ID: <8312fdd3-9a69-f9e3-1ab0-ea95df577cf9@nvidia.com>
Date:   Fri, 25 Feb 2022 10:00:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2 09/12] vxlan: vni filtering support on collect
 metadata device
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        stephen@networkplumber.org, nikolay@cumulusnetworks.com,
        idosch@nvidia.com, dsahern@gmail.com, bpoirier@nvidia.com
References: <20220222025230.2119189-1-roopa@nvidia.com>
 <20220222025230.2119189-10-roopa@nvidia.com>
 <20220223202509.439b9c6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220223202509.439b9c6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d92b11e-b975-47e9-c1a6-08d9f888a596
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2464:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB24649F173BF99B0137D2A5E5CB3E9@BN6PR1201MB2464.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zcPqgImJq6Z0kPTfenJlKxISS4Q87X8hpOZPcYY1hp4DpbeGYyLAocKULlufUucIiFF3VU6Hdx1rF9Yeb1elAJFWb1ZdZjJj+mN1GbdzJj/7D9LWpRUqYF/sRbaq9wh6ZiNwyncP3PPLDVdKT79HFMd2Ih7UTIwhVEXM5Xb0IU7lUuAG1wAWc13xRYsLYBvH1gpUffXbWRyBg6fq+OyfiHOosC4B7j0i+GZTBNGvWw5HS3WhVYBNenu88iLJCRE5PKt5E2zXUxSkBVCYbJY4fTo1kh5YzsjkSefyVnsO0d0HQwlnFWi3RH4KwuA24yjo5NfwBzO1xtwHKH6h56vLEp0KlKHYXnzUUU/8ZP5wkk7CzayRzpZAwGGAUvf1JDgMfnEO9DGDYEaM/gCVOgC/dUYumMojy7Ovp8+yG9QokCMh3wHaXKm9u3E4dz5WPYN2FcMoD8l1beiOLi6UVIeuc1IT/BIjh7uLyCNAH2kKjuimPA5/65wXUCrkMgfIvJTheofslInp9PsLw8qdV0kwtjr4ZiKLEoQbpjwc2h0hyY6efENtXwDxFPCu9gcNfXhIFfA8/tvlSuUsOdhlyhqXO50OOuZQqdNUGbDxWPIsInLTeyAkC6gvq2mCLlpZ70Ju9xOWoeemmyLjujKi62SlmmE7Wc/oTGrme1CUGG8Tpt1mQaSGwglt58hQpkSkUEkByezaNNzN6nXJSNNWmwY2CqsQlrQ5Qt85WYR29ogAgAyWcjKWPW03789uWLPR1M18
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6512007)(53546011)(2616005)(83380400001)(2906002)(107886003)(186003)(36756003)(6506007)(31686004)(5660300002)(86362001)(31696002)(8936002)(8676002)(4326008)(66946007)(66556008)(66476007)(6486002)(6916009)(316002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFoyMUlZcU5Db1pGLzdsYUtueERrdTJWN3MyV1ZxWGRtdlc3WGlhTXd4RHEx?=
 =?utf-8?B?a3VkNEpBd2tBVURVMnR4NXJKMVdod25iNlZCTlpNa0l1OEFRNk9DZlhCa1pi?=
 =?utf-8?B?ZUhHbGoySEE2M0MyaEFkSHUwTGphd2dBenJUTlZKVmVhY3FjcytnaU5rZjVT?=
 =?utf-8?B?SEZyaEhzYUhMeXRaKy8wQktHY2lOYUdNYjJTNFdEVnJHRWJrcVIxY0pTbGgx?=
 =?utf-8?B?ZWhKZDNkQmRWTWdudVIya1FnU0FOMVJPaHpkbjZ4cGt6S1hNZ2NHQ3BtSmV0?=
 =?utf-8?B?UHVsQkRUaWtoZ2x0aUNodXk2MmhHZHlvN045azkzRDFkRkJ5Q0RqYzdhM3A2?=
 =?utf-8?B?M1N2eW9aQnlEUDI3U2M1UUFjY2hvN0lTSENYT2JOK0liWGs4S2RFSGo4RjBx?=
 =?utf-8?B?U1R2bVViY1VsYjZFT1FqY1FYZDgzN04vdmRIclp4Qi9xSm5vUWNBS3h3dTlq?=
 =?utf-8?B?VWdEYVZSOFhtdG01VFZRMk5lcmF4aHkyaC84SThpYTBwdG1RYWttbGNENUxm?=
 =?utf-8?B?S1ltUUdxd3g3ekliWjMzREt1UjlSNmMwRVE4Q21RRGNiSVc0ZTczNkdrWXZZ?=
 =?utf-8?B?czhYOWVyVUllcWQxTlFwbVVIUUtLSUt5WVVFYkNhbythbGc2NkNpYjVlb1du?=
 =?utf-8?B?eklReXZLR3NyMFFHQmU3UlorRGlsREw4MHpPbllyY05qU0JzdkpTSXRkOTY3?=
 =?utf-8?B?TzJHNFFMUlFPYWwzekR5cnlHZlFkakpLM0RBZ3l2REE5YkhERGdaTEQrc1hx?=
 =?utf-8?B?V0xPQ2FyK21zbyszWUEybzYxMUF0YXdvczFBUisrU3cwNFVKNWY5SVFnZ0Vm?=
 =?utf-8?B?SEJnVzdBQnF6bEZUdk1ZNEtCb05VSDlsd2dVNEFmVU9DZzdVZmNDaU8vOFV6?=
 =?utf-8?B?SFJ6UjMvZCtCV3ZxaERjRUhVcHM5MHptZWZHbnlWc1hoOHBQTFkrejBOL2ky?=
 =?utf-8?B?WFZ1ZzE4TVJKVFFvZmVUWXpvTlpUVVNxNTN3SUVvUkVob2RuR0tXcHU4YVdq?=
 =?utf-8?B?bEx6dWZxMDFkSGxSM2k3SXZBREZXTXFYUCthNkFrYlhDTm1EaWxEdlBHMVJN?=
 =?utf-8?B?SXovZUovczVtaVYwbW1RdGhDVEhON1JMNFZXQXJWaEUwQjlTNUVSditUM2Fo?=
 =?utf-8?B?aUNxQ3J0UnRmUVhoelZwRXBEVnJCdk4rRzFOYTUveEgyRUJRT3lIN2JpTXBv?=
 =?utf-8?B?KzRkZVpHd0VwdkltcnVQOEt0clp3RXNDQmpIcVlHeFhKSWFIdGZJOG1VcWpo?=
 =?utf-8?B?YytwVllhRXpGekRWeWViVGZwSTR6V1B5K0xKSkIyWXhjRk5jVE5hMW84b1dB?=
 =?utf-8?B?MDc4SVF5cjYwS00wcmlMTXJ2MTNKa3FzMnRZWitHQzNvZDhTd2NoWTNrZkJM?=
 =?utf-8?B?RmUwT0FURzlPSHJGeG1ZWElFU3NXTVRLM2YzNXQzUUZPdkY0dVcyMGFKV0g4?=
 =?utf-8?B?ZTJqdTlCNWpOa3hzYkd1MVc2Y216b0s4b2UxbGljNlBVM2t3SThvMHZxUzAy?=
 =?utf-8?B?QXczb3QzdkRMR3hNSlYwekZIcDNzeU56bDdPdnBBaVRtWXp3d2xCcVBmQnFn?=
 =?utf-8?B?bmNEYVlscmhkTC9vODIrcVY3R1BrUlNYUExDY2ZjeTI5NFpGL1ZxRjJQc0VH?=
 =?utf-8?B?eWUrQW1EMmU0cmNCeWxKbjJJTlRVRFdqTHpVcGs5RnN6ZXloQjJER2ltKyth?=
 =?utf-8?B?c1E2ZllsWC9KYzFZSkRaNjBEMDlSeFNjVDRXSzUyZS8xQ21teXJ1OVlueVlK?=
 =?utf-8?B?aFAyWW1vQVFaSVExZWxmalg5K3R5dUY1clloaWVSdU5RT2Z1TmdoWnBjUlU1?=
 =?utf-8?B?OHF1UmUrc0p2SkQ0SnpLSGc1aFVZUk8vYUlZenZ1anRaa2gxMVRhWHlKVG10?=
 =?utf-8?B?Ykl3SDJaWXVpMWlpYW04ODB5bHF2K3VMYjROTmk4aHVOUXFRbjNramszdTFV?=
 =?utf-8?B?S2svVzlBaDNxRVAxcHlsOVZSTGV4UnZkbmEzOWgzUHd0ME9OaCtSWVRlRWpy?=
 =?utf-8?B?dlFVZWYza0NKd3cxdDA3SW56Y2xkKytkS0dmWWYwajQxVDA1SDdkbVZtRU5l?=
 =?utf-8?B?MzhQRUR0SW1qRkRYa2NwaDNJcmZscC9QMlBqbE1VYjRTelFMR0NIMlVDZkxZ?=
 =?utf-8?B?Y3I1djdWNTJTemFOQkVlNzIvRHhFVU9kTWZ3UVdERDE1eVVxbll4akJoeUZ3?=
 =?utf-8?B?eisxZ0Z0VnovREJ1NUYzeGFnOFpmb1N4blRGUzh6TUVrRjZCTzhnVCtQcWtW?=
 =?utf-8?Q?UKPLrKQfLyrOb29RQlC69Pvv5ClvEwtnao2zlxKU3U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d92b11e-b975-47e9-c1a6-08d9f888a596
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 18:00:02.9353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4yV9QqtH5VA5e53SagzfSGdUBUFawI1w5PJt7okacFBfRGQBjGDY6URMRA1aEN9Z82g+9Y5GgGU2/xVt6yDorg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2464
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


On 2/23/22 20:25, Jakub Kicinski wrote:
> On Tue, 22 Feb 2022 02:52:27 +0000 Roopa Prabhu wrote:
>> +static int vxlan_vni_add(struct vxlan_dev *vxlan,
>> +			 struct vxlan_vni_group *vg,
>> +			 u32 vni, union vxlan_addr *group,
>> +			 struct netlink_ext_ack *extack)
>> +{
>> +	struct vxlan_vni_node *vninode;
>> +	__be32 v = cpu_to_be32(vni);
>> +	bool changed = false;
>> +	int err = 0;
>> +
>> +	if (vxlan_vnifilter_lookup(vxlan, v))
>> +		return vxlan_vni_update(vxlan, vg, v, group, &changed, extack);
>> +
>> +	err = vxlan_vni_in_use(vxlan->net, vxlan, &vxlan->cfg, v);
>> +	if (err) {
>> +		NL_SET_ERR_MSG(extack, "VNI in use");
>> +		return err;
>> +	}
>> +
>> +	vninode = vxlan_vni_alloc(vxlan, v);
>> +	if (!vninode)
>> +		return -ENOMEM;
>> +
>> +	err = rhashtable_lookup_insert_fast(&vg->vni_hash,
>> +					    &vninode->vnode,
>> +					    vxlan_vni_rht_params);
>> +	if (err)
> leak ?

ouch, will fix.

>
>> +		return err;
>> +
>> +	__vxlan_vni_add_list(vg, vninode);
>> +
>> +	if (vxlan->dev->flags & IFF_UP)
>> +		vxlan_vs_add_del_vninode(vxlan, vninode, false);
>> +
>> +	err = vxlan_vni_update_group(vxlan, vninode, group, true, &changed,
>> +				     extack);
>> +
>> +	if (changed)
>> +		vxlan_vnifilter_notify(vxlan, vninode, RTM_NEWTUNNEL);
>> +
>> +	return err;
>> +}
>> +
>> +static void vxlan_vni_node_rcu_free(struct rcu_head *rcu)
>> +{
>> +	struct vxlan_vni_node *v;
>> +
>> +	v = container_of(rcu, struct vxlan_vni_node, rcu);
>> +	kfree(v);
>> +}
> kfree_rcu()?


you are right it can move it to kfree_rcu in this patch. But, later in 
the stats patch, this also frees up stats.

so, wont be able to switch it to kfree_rcu. but will look again.

>
>> +static int vxlan_vni_del(struct vxlan_dev *vxlan,
>> +			 struct vxlan_vni_group *vg,
>> +			 u32 vni, struct netlink_ext_ack *extack)
>> +{
>> +	struct vxlan_vni_node *vninode;
>> +	__be32 v = cpu_to_be32(vni);
>> +	int err = 0;
>> +
>> +	vg = rtnl_dereference(vxlan->vnigrp);
>> +
>> +	vninode = rhashtable_lookup_fast(&vg->vni_hash, &v,
>> +					 vxlan_vni_rht_params);
>> +	if (!vninode) {
>> +		err = -ENOENT;
>> +		goto out;
>> +	}
>> +
>> +	vxlan_vni_delete_group(vxlan, vninode);
>> +
>> +	err = rhashtable_remove_fast(&vg->vni_hash,
>> +				     &vninode->vnode,
>> +				     vxlan_vni_rht_params);
>> +	if (err)
>> +		goto out;
>> +
>> +	__vxlan_vni_del_list(vg, vninode);
>> +
>> +	vxlan_vnifilter_notify(vxlan, vninode, RTM_DELTUNNEL);
>> +
>> +	if (vxlan->dev->flags & IFF_UP)
>> +		vxlan_vs_add_del_vninode(vxlan, vninode, true);
>> +
>> +	call_rcu(&vninode->rcu, vxlan_vni_node_rcu_free);
>> +
>> +	return 0;
>> +out:
>> +	return err;
>> +}
>> +
>> +static int vxlan_vni_add_del(struct vxlan_dev *vxlan, __u32 start_vni,
>> +			     __u32 end_vni, union vxlan_addr *group,
>> +			     int cmd, struct netlink_ext_ack *extack)
>> +{
>> +	struct vxlan_vni_group *vg;
>> +	int v, err = 0;
>> +
>> +	vg = rtnl_dereference(vxlan->vnigrp);
>> +
>> +	for (v = start_vni; v <= end_vni; v++) {
>> +		switch (cmd) {
>> +		case RTM_NEWTUNNEL:
>> +			err = vxlan_vni_add(vxlan, vg, v, group, extack);
>> +			break;
>> +		case RTM_DELTUNNEL:
>> +			err = vxlan_vni_del(vxlan, vg, v, extack);
>> +			break;
>> +		default:
>> +			err = -EOPNOTSUPP;
>> +			break;
>> +		}
>> +		if (err)
>> +			goto out;
>> +	}
>> +
>> +	return 0;
>> +out:
>> +	return err;
>> +}
>> +
>> +static int vxlan_process_vni_filter(struct vxlan_dev *vxlan,
>> +				    struct nlattr *nlvnifilter,
>> +				    int cmd, struct netlink_ext_ack *extack)
>> +{
>> +	struct nlattr *vattrs[VXLAN_VNIFILTER_ENTRY_MAX + 1];
>> +	u32 vni_start = 0, vni_end = 0;
>> +	union vxlan_addr group;
>> +	int err = 0;
> unnecessary init
>
>> +	err = nla_parse_nested(vattrs,
>> +			       VXLAN_VNIFILTER_ENTRY_MAX,
>> +			       nlvnifilter, vni_filter_entry_policy,
>> +			       extack);
>> +	if (err)
>> +		return err;
>> +
>> +	if (vattrs[VXLAN_VNIFILTER_ENTRY_START]) {
>> +		vni_start = nla_get_u32(vattrs[VXLAN_VNIFILTER_ENTRY_START]);
>> +		vni_end = vni_start;
>> +	}
>> +
>> +	if (vattrs[VXLAN_VNIFILTER_ENTRY_END])
>> +		vni_end = nla_get_u32(vattrs[VXLAN_VNIFILTER_ENTRY_END]);
>> +
>> +	if (!vni_start && !vni_end) {
>> +		NL_SET_ERR_MSG_ATTR(extack, nlvnifilter,
>> +				    "vni start nor end found in vni entry");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (vattrs[VXLAN_VNIFILTER_ENTRY_GROUP]) {
>> +		group.sin.sin_addr.s_addr =
>> +			nla_get_in_addr(vattrs[VXLAN_VNIFILTER_ENTRY_GROUP]);
>> +		group.sa.sa_family = AF_INET;
>> +	} else if (vattrs[VXLAN_VNIFILTER_ENTRY_GROUP6]) {
>> +		group.sin6.sin6_addr =
>> +			nla_get_in6_addr(vattrs[VXLAN_VNIFILTER_ENTRY_GROUP6]);
>> +		group.sa.sa_family = AF_INET6;
>> +	} else {
>> +		memset(&group, 0, sizeof(group));
>> +	}
>> +
>> +	err = vxlan_vni_add_del(vxlan, vni_start, vni_end, &group, cmd,
>> +				extack);
>> +	if (err)
>> +		return err;
>> +
>> +	return 0;
>> +}
>> +
>> +void vxlan_vnigroup_uninit(struct vxlan_dev *vxlan)
>> +{
>> +	struct vxlan_vni_node *v, *tmp;
>> +	struct vxlan_vni_group *vg;
>> +
>> +	vg = rtnl_dereference(vxlan->vnigrp);
>> +	list_for_each_entry_safe(v, tmp, &vg->vni_list, vlist) {
>> +		rhashtable_remove_fast(&vg->vni_hash, &v->vnode,
>> +				       vxlan_vni_rht_params);
>> +		hlist_del_init_rcu(&v->hlist4.hlist);
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +		hlist_del_init_rcu(&v->hlist6.hlist);
>> +#endif
> no need to generate the notifications here?


great catch, will fix.

>
>> +		__vxlan_vni_del_list(vg, v);
>> +		call_rcu(&v->rcu, vxlan_vni_node_rcu_free);
>> +	}
>> +	rhashtable_destroy(&vg->vni_hash);
>> +	kfree(vg);
>> +}
>> +
>> +int vxlan_vnigroup_init(struct vxlan_dev *vxlan)
>> +{
>> +	struct vxlan_vni_group *vg;
>> +	int ret = -ENOMEM;
>> +
>> +	vg = kzalloc(sizeof(*vg), GFP_KERNEL);
>> +	if (!vg)
>> +		goto out;
> return -ENOMEM;
> the jumping dance is really not worth it here
agreed :)
>> +	ret = rhashtable_init(&vg->vni_hash, &vxlan_vni_rht_params);
>> +	if (ret)
>> +		goto err_rhtbl;
>> +	INIT_LIST_HEAD(&vg->vni_list);
>> +	rcu_assign_pointer(vxlan->vnigrp, vg);
>> +
>> +	return 0;
>> +
>> +out:
>> +	return ret;
>> +
>> +err_rhtbl:
>> +	kfree(vg);
>> +
>> +	goto out;
>> +}
>> +
>> +static int vxlan_vnifilter_process(struct sk_buff *skb, struct nlmsghdr *nlh,
>> +				   struct netlink_ext_ack *extack)
>> +{
>> +	struct net *net = sock_net(skb->sk);
>> +	struct tunnel_msg *tmsg;
>> +	struct vxlan_dev *vxlan;
>> +	struct net_device *dev;
>> +	struct nlattr *attr;
>> +	int err, vnis = 0;
>> +	int rem;
>> +
>> +	/* this should validate the header and check for remaining bytes */
>> +	err = nlmsg_parse(nlh, sizeof(*tmsg), NULL, VXLAN_VNIFILTER_MAX, NULL,
>> +			  extack);
> Could be useful to provide a policy here, even if it only points to
> single type (entry which is nested). Otherwise we will not reject
> UNSPEC, and validate if ENTRY has NLA_F_NESTED set, no?


yeah, any policy is better than no policy, will fix.

thanks for the review!

