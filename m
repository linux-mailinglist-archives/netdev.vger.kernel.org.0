Return-Path: <netdev+bounces-4218-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A3B870BBBD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:27:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C45231C20A02
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0265BBE69;
	Mon, 22 May 2023 11:27:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36CFBE5B
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:27:47 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::71f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A387AB6
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 04:27:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pov/H17RttSD2GCPK9e+GLfPxrnpIdibZ0sOdZKqiclUxHccWoHMd1TfgxwgHJ1AZH3kW/zAMFHzNs+6Eqyzi0LbVlLlVONSjujCA/I6RnlG/gJZ92UnSZYd7HRLNDUFbOZsSGK+zoVperXLzqocG+Ewi9bxggdZcYLq8yALDNF4S4x0e6Wue1BoQV/ayMiOl3jhEzSfz2z6iu58bEJ1FdagAdE2L4lSUO8OLjDd51nlntUPPNB160PVzJfFO3SdiSn1QO5t1Vg3wThgX/F6l4LnRpbjm1tkW9cn3R8wPzkbWdSXCw3UNPqqk8bnMFYv0IEKThASfnFSb1qunbFKlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EqLzfRl/GU+d0Brrl1Ag9p76jZw44nYWGhZMfP5mvOk=;
 b=fYFR7PfvwH8PWK3xt5qhR2DeWjWponw9fNZMKYhIFGePRa3RNQ7VYr5GFZo7WTL4vM/X4jDOjW/j3b9T7p/sBoakcjtvOLwvdE8q1OKwjhMvVtElRAm1KyrAZyk3QuoVn8FP3kWcJf6a6qr5Ui4Gt2ryYE3Iyl1vPxrFVOeKj+/qzCeovsh3hk8zcGsE5ymqRo1CrydJTAhYlCK6AvST9RXLFZJQhOkvtrHWM/Z7wdIXidyr7KWQoRCTJPCJ5C3K5F8FCBxQenyA4hxbVkgqLcIKVvfrJ6mIjTAdeqRtHFtCm0fAAPKwhZVTdqbTqySGCH196A0KE+MjBfF5899isw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqLzfRl/GU+d0Brrl1Ag9p76jZw44nYWGhZMfP5mvOk=;
 b=SIazZv5xSmtYQbEJZgj6VMSmG6iVZJmYwJQnZO2rsRVRfqfhWS1IlslpxQ/q2fr+U2FMJtxdLC8Om0znHIBxPHazCX2Zu4nEnMYgyhvnyW38e9EA/izvyAE2oqGG+JXd9hQGtgYhUNf06g8Cf+AmRdpldbEdVvT9Yd6HG2wuv3U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4448.namprd13.prod.outlook.com (2603:10b6:5:1bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 11:27:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 11:27:43 +0000
Date: Mon, 22 May 2023 13:27:37 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Wojciech Drewek <wojciech.drewek@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	alexandr.lobakin@intel.com, david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com, sridhar.samudrala@intel.com,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH iwl-next v3 08/10] ice: implement bridge port vlan
Message-ID: <ZGtRqTaWtKYbI+f1@corigine.com>
References: <20230522090542.45679-1-wojciech.drewek@intel.com>
 <20230522090542.45679-9-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522090542.45679-9-wojciech.drewek@intel.com>
X-ClientProxiedBy: AS4P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4448:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c421c5e-b9fa-4c6d-e1dc-08db5ab78f2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qEw606JbJ6kE0eAOaQ/3qDNEpVMfLGyUoLh10jSRe7NIC2hZwW9yIn8rr0fHAZV4JRcR9ReBJ9fqemAxk1y/OsM3egQ0mqO8pX9xvI13hpyiO07+nJKzYseHxmFZWYUsSGi1Z4iVURJb8Luo1dR/ANVBjF5LKzeRtalMwKLidl+UwJUXs06MsJ/2Qm8cb6feI/T1envKUsAycthH2zemctzkIlUwfoLAvKA+iDKVPu0fG96zUH+jfw4WRxeqrU/ocUPhaov5gsX+krgWUflWjhXKBdR8trZmE+peKFhhlGeVRsC/PexxBRSJ/vjMYCpevdeejcNMhpw/6nXd5e5dUFiKOd85e5YeRPj3AlB8wbFw3d0qqMZsTDh5um/zhW/e6/wVIWbWwGN+XsKlFNl3RmleqdZz74kFClsHwxs/WjhuAlOT4U9pG8EiuzXCt8m3nH4N7n7LPnCkktrAOO5AIM4f4TorYbYPJGPlRI/dX1enFF0Mnu6/UYGE+mY6ZOT1/AS+jBMnJaD8RcKTtPaaIp/GXAzOxGqNZpeeXnORGhBYmoczT1WAgatflu7CsOC3daNf7zRBgF0ltASduwvePl/jKE1n3PoJnoYIyATgWXE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(39830400003)(136003)(451199021)(41300700001)(478600001)(316002)(6666004)(6506007)(6512007)(6486002)(6916009)(66556008)(66946007)(4326008)(66476007)(8676002)(5660300002)(7416002)(44832011)(8936002)(36756003)(186003)(38100700002)(2906002)(83380400001)(2616005)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UUE9FNBi9Cuux3oh44QYCJxDm8Va9OzB/8o6F2PZdvxGjzMdD1CZqQ3nkYqJ?=
 =?us-ascii?Q?TpURI7LuSVKiGnM49L2NLWZj4PJUUUUCrVcTmXjSmu0k+72NZxJE2NEgIdip?=
 =?us-ascii?Q?D7hBMax5tHq/KBggLnxZDDoAI/GVBQbeBkzZyxgGLF1u6smf8qw8S4HqO327?=
 =?us-ascii?Q?+hcDj3NLqa/ifLMWogF1i5tl/MTBVi7gKWAEdRCkVqyzjp0jihyeIdDNRZBB?=
 =?us-ascii?Q?SkUkXdXPLkZqUMXbe6TaCPBl3CiblgFosilvpDgECBrqa18oETMVzzjyWuiB?=
 =?us-ascii?Q?HhoR0auj5Ll6qZA+ah2orxXeuJusyURRF1QTBqlp0yrDYZW+LareqH0fDs15?=
 =?us-ascii?Q?MU0bf0IBLpLu0WcFOUj9VSiq34SHETPXrNTp9H9or4q4PFNXYT+0aawC4wbc?=
 =?us-ascii?Q?7++ruTW2qDsfI7KYH4J5sqy7f1dXH7IOLAs/tkwdAxr9PHr9KrNP3GtKMtDx?=
 =?us-ascii?Q?HoxV+vMgs8h44ILQD+HHHnMApGBvPy5HKiVFIO6TY0fjTwhXIHi/hQa6Swud?=
 =?us-ascii?Q?ZtQuPK2Z0dZnKt2uLVlGGflOKMTvFbvoFPgmAHdajTA8ZJLIpzFQI82ii+go?=
 =?us-ascii?Q?qnPdEKGME3zrRlzrfZFtKxrJwyk3pkJCD605Iu5LcKFYoegpxt7OjSWITSbj?=
 =?us-ascii?Q?NOo7NRkCqiqOyUcfzUG0CBFL37vXviEOn7Ad6eQu24qp/LLmJbhzeJ98aebz?=
 =?us-ascii?Q?XE6ge3xLuXXhyJwpTopJah8xEKSO+ZJHheGn0uBKJzzwM0dasPb1ufxxVY8x?=
 =?us-ascii?Q?0+o6R9SQDGa/GIAhXXtKiKAxlP4S8NekGBHc9xp/n5eJx21E7+BfTpjpg6qg?=
 =?us-ascii?Q?tLb/MebpYbyamzJSAnwZnnDN+EYSeyFcdg9MfLsXV+Y+ID+IrbwB1N1wFpl1?=
 =?us-ascii?Q?IdO6Fj0gJ6ajxXnuA7nQY8mejD3PMsrxq3Irew6o1oNWl1bGymuITV7Peo4Z?=
 =?us-ascii?Q?6IdGVcv04jc+yr4Uw4OkrM9mHSTTh6DgXqclDtaMl+4weGEqexiU5YCTRkIG?=
 =?us-ascii?Q?SQEW4FyCBfzlqGS+9GpqAeLBEZ3pE1Ms3CnbII3UOTCvK9DIobJWMRznSfmC?=
 =?us-ascii?Q?Dmt4Wcm/23dWic52BPePdsN6tbyEUcCT1oHsDtaMlT5RcyvfrKPs/8zBtD8G?=
 =?us-ascii?Q?riMhibEquwaYCH/waWnkKdRU9zfFw2acmHHpifI5j+LgJA2uPAM7xYm7bZyg?=
 =?us-ascii?Q?qKgHsjWN+uhUOv5XQWLiYEhIm6K9sexfYRFx0kMlC0Y/oYE8LmPfGkyhADu/?=
 =?us-ascii?Q?v2Du0gAGzVScvwnWO6giYIzZ/jEA0/zUBlRAU8pDRpXewXw98Cav8uN2F66C?=
 =?us-ascii?Q?sUmnAk7ZZZsOT0EA+guaAsETfikld+yYcLelkK2BUvjFNaid7F0GgaFj+Ktj?=
 =?us-ascii?Q?HEt5NI6/QGjNmdh6Jin8duAM1Y3KXa4Xd/zDdkQkoKW4+o5P7uF9Oa0+NUmI?=
 =?us-ascii?Q?NBCFr1uage4nOVq/oJmam1wlyqVISqp9WYSz988hAMLI7x1k1RLRMOrnGO8g?=
 =?us-ascii?Q?6DI5Tu9SHAayzg+9WXuR3sFg9gmIG4BY2jSYz+JXPsz1lMLhBtQ0bZ6hlut9?=
 =?us-ascii?Q?iWSkmzSmU2BzLNLrVNWE5aPxK7gaL53cP+DEscObgyjTpMdMJqoZy+y3nPil?=
 =?us-ascii?Q?3CfqzpwAJuScJAxN9uTLJx5PseO2LGdAvlK/INYf6/5ABHZFLqVa2KxQP+jX?=
 =?us-ascii?Q?AexBpw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c421c5e-b9fa-4c6d-e1dc-08db5ab78f2a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 11:27:43.1845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uk//HPkySZw8rv9SZk2Cl3YHzMyY45/I7dvOOHPDzHWZDgELbCY7ONpaxrvV+cJ4Ravll5eR5z6Uw+M0LF0JiK4/HEZHxvb9aFpdoBieP0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4448
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+Dan Carpenter

On Mon, May 22, 2023 at 11:05:40AM +0200, Wojciech Drewek wrote:
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> 
> Port VLAN in this case means push and pop VLAN action on specific vid.
> There are a few limitation in hardware:
> - push and pop can't be used separately
> - if port VLAN is used there can't be any trunk VLANs, because pop
>   action is done on all traffic received by VSI in port VLAN mode
> - port VLAN mode on uplink port isn't supported
> 
> Reflect these limitations in code using dev_info to inform the user
> about unsupported configuration.
> 
> In bridge mode there is a need to configure port vlan without resetting
> VFs. To do that implement ice_port_vlan_on/off() functions. They are
> only configuring correct vlan_ops to allow setting port vlan.
> 
> We also need to clear port vlan without resetting the VF which is not
> supported right now. Change it by implementing clear_port_vlan ops.
> As previous VLAN configuration isn't always the same, store current
> config while creating port vlan and restore it in clear function.
> 
> Configuration steps:
> - configure switchdev with bridge
> - #bridge vlan add dev eth0 vid 120 pvid untagged
> - #bridge vlan add dev eth1 vid 120 pvid untagged
> - ping from VF0 to VF1
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>

...

> @@ -639,14 +698,29 @@ ice_eswitch_br_vlan_create(u16 vid, u16 flags, struct ice_esw_br_port *port)
>  
>  	vlan->vid = vid;
>  	vlan->flags = flags;
> +	if ((flags & BRIDGE_VLAN_INFO_PVID) &&
> +	    (flags & BRIDGE_VLAN_INFO_UNTAGGED)) {
> +		err = ice_eswitch_br_set_pvid(port, vlan);
> +		if (err)
> +			goto err_set_pvid;
> +	} else if ((flags & BRIDGE_VLAN_INFO_PVID) ||
> +		   (flags & BRIDGE_VLAN_INFO_UNTAGGED)) {
> +		dev_info(dev, "VLAN push and pop are supported only simultaneously\n");
> +		return ERR_PTR(-EOPNOTSUPP);

Hi Wojciech,

Smatch thinks that vlan is being leaked here.
So perhaps:

		err = -EOPNOTSUPP;
		goto err_set_pvid;

.../ice_eswitch_br.c:709 ice_eswitch_br_vlan_create() warn: possible memory leak of 'vlan'


> +	}
>  
>  	err = xa_insert(&port->vlans, vlan->vid, vlan, GFP_KERNEL);
> -	if (err) {
> -		kfree(vlan);
> -		return ERR_PTR(err);
> -	}
> +	if (err)
> +		goto err_insert;
>  
>  	return vlan;
> +
> +err_insert:
> +	if (port->pvid)
> +		ice_eswitch_br_clear_pvid(port);
> +err_set_pvid:
> +	kfree(vlan);
> +	return ERR_PTR(err);
>  }
>  
>  static int

...

