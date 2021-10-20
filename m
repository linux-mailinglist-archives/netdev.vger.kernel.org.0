Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2122243465F
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhJTIEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:04:34 -0400
Received: from mail-dm6nam12on2079.outbound.protection.outlook.com ([40.107.243.79]:3619
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229663AbhJTIDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 04:03:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z71pGGNTSX+3GD6YQPB7T9aaWEYCQvEa7xUC1AvsOYmiPVQqHB5KA0iKDgB+jCWQ4b/exn99X9ly79rjYlI9GjRwKdyNsYeeTMRsUeg0sZkoHJewX7ZvuV7EyRAUQbzqzlqB4Af9ja78FcViwKfqLOcFolOa7ewbxoDp36FCtSDcoNpIrolQI4HAECxR2mFgjeFViavOcFeHrDXrAGD/6c997Bky3WAvM0lJHHEvp3e3InssQn12uTlugVT1IwzakBgJ+UVUZV0R6PlEBRfZv5f03yw+vY9LGP2551RQX5QDyBq+jRSepx7CBTmrIfuc9GpDqTaFvXpR6jeChaeSKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulzNiQ/sv4sRvLSvlcCyESt9PglyDv9qxuuhHHx8bUk=;
 b=YJA73Qb6FuIj7JkCEarSQX5+3cOL9hPdjuUKCQhaEg6V+Zu2S1PA3PUJfl3rc+smSabMACCqET8B8/H9qe6jGYFzHkEzOIla5fzrUJpxEHl02SJ2KZ1nEAx93BaKA1OKjNALdWQspvvO2+Qu5D5M75YT0/Qxfaml7yQgRec+7t5B66p6RM72KWI1PwftTwjJ8zDuYj0I/EeSP0BuvdSgoBhgRan689I3RY0lAT4sZ6Md5xAb+BZPi4CEMoDvuxF8eyIF2NRScSsl3IMH4ifkrKCCdw2n7OHzZyE2ch/HJuGLpLK/CxEKBUFbNMb/nHCdj9vVdCKLRCR7KJ20RVwhWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulzNiQ/sv4sRvLSvlcCyESt9PglyDv9qxuuhHHx8bUk=;
 b=tRt52xdInh+6L8IE96fxaX3uuUnzWWzWXVLLXShXDw8qC1BvPkOZqHd5+pCLIrSr1vjNzrwLSWgJPg5+cFuKm+58x/QsSCS5GxQ/xuRh8heR+rpn/7Klfj75yw7HvZpR++iqqlFJbc5LXC07VeOJSyaa13B2QEiMHDaRry0aw/6FD5p3d7Ffp1LT+ffmpos0viTke02eI5w7l3GHdGN2v53gL8YBt/L9Ht+lVVS1bKjl+vS+37sWG8ebEg+1M89Kdf8gn5sDO/EuUOL3VJG7MZQqNvjG3E6Fo6fRzW3jVpSp5rFSZb3lYQQ5fDS3eU3DTrs+N8FQPKSCP6uRS6FmXQ==
Received: from DM5PR21CA0062.namprd21.prod.outlook.com (2603:10b6:3:129::24)
 by BYAPR12MB3447.namprd12.prod.outlook.com (2603:10b6:a03:a9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Wed, 20 Oct
 2021 08:01:10 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:129:cafe::be) by DM5PR21CA0062.outlook.office365.com
 (2603:10b6:3:129::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.1 via Frontend
 Transport; Wed, 20 Oct 2021 08:01:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 08:01:07 +0000
Received: from [172.27.15.75] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 20 Oct
 2021 08:01:03 +0000
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     <bhelgaas@google.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-13-yishaih@nvidia.com>
 <20211019124352.74c3b6ba.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <d5ba3528-22db-e06b-80bb-0db40a71e67a@nvidia.com>
Date:   Wed, 20 Oct 2021 11:01:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019124352.74c3b6ba.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9ec67d5-e3a4-4757-c163-08d9939fc602
X-MS-TrafficTypeDiagnostic: BYAPR12MB3447:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3447D741EEA6E7B1D4208EB6C3BE9@BYAPR12MB3447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YzXa476lr9SjJIPX8/nKAmG/u7k0dtNOq2SxHVU0xpmlj0BsKyDtBsw4Gif4bNsRmYf1e42xJbXQosRm4/nOZhCk1VPqKlrEvC4PEM3MpQ2tYznBVgGhcVUogd8U1XKEphCgQynDZjKXnSnk7Ep3Z5u/v8plG+M7OjlyVYSIWxG4WmwQ7akLfdBelClb834uVLSebxvtlSqdzTnxN/Re+DbiqhlhMr8yUMpHpVASWpJbrtuPZY0vPCBHU+TnDZwmq1qfLArz4DtpRMQMNMHl8DvPD9X/NoY7vMn7fRuUjEZSV90/jt0S2KIWZW7J9kBqFGyTJH7lj5Q/XnVBlPN2UHuJe5qFgRHVWXOw7g4I0IaLRhMJrMa3XoJnC/ZQxqM1wXgb6867bRpUjKj7GYCNDA5SLsGQNaWH6JfPNEez60Z0hbSxM9j5kAcAa1BgXayaxin+f+UTPWWIpqLOfG8PcjjxsEW0D7QVcg5c23EgPu3PoD9Eblm7jHpZ5gAXgf3S8kgZFQRwrCFS3JXka0IyyPMCjHhJtSXQZ31bxXUEpzd8ZOAgATZQ+cKBZOIKLtaIMMFyNLuMssi3Ci3HgbYd+O1uk4Z8d7mvTT7YMVxFgfTGhbNVK8LDpncO1xeWfVja/rm/3wwBnytoaFov7elePIlHGgpPq0UqgLZfcB4iiYXFZiti4G67CXsSfa5LZVWx83MBZbEEYUsrqrY7cSvVo6p6IxAKhD+H/XisodhAUxo=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(356005)(36860700001)(426003)(70206006)(70586007)(54906003)(16526019)(186003)(7636003)(53546011)(8936002)(336012)(107886003)(86362001)(5660300002)(2906002)(316002)(16576012)(82310400003)(6636002)(31696002)(47076005)(8676002)(110136005)(2616005)(31686004)(36756003)(508600001)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 08:01:07.6101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ec67d5-e3a4-4757-c163-08d9939fc602
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3447
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/2021 9:43 PM, Alex Williamson wrote:
>
>> +
>> +	/* Resuming switches off */
>> +	if (((old_state ^ state) & VFIO_DEVICE_STATE_RESUMING) &&
>> +	    (old_state & VFIO_DEVICE_STATE_RESUMING)) {
>> +		/* deserialize state into the device */
>> +		ret = mlx5vf_load_state(mvdev);
>> +		if (ret) {
>> +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_ERROR;
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	/* Resuming switches on */
>> +	if (((old_state ^ state) & VFIO_DEVICE_STATE_RESUMING) &&
>> +	    (state & VFIO_DEVICE_STATE_RESUMING)) {
>> +		mlx5vf_reset_mig_state(mvdev);
>> +		ret = mlx5vf_pci_new_write_window(mvdev);
>> +		if (ret)
>> +			return ret;
>> +	}
> A couple nits here...
>
> Perhaps:
>
> 	if ((old_state ^ state) & VFIO_DEVICE_STATE_RESUMING)) {
> 		/* Resuming bit cleared */
> 		if (old_state & VFIO_DEVICE_STATE_RESUMING) {
> 			...
> 		} else { /* Resuming bit set */
> 			...
> 		}
> 	}

  I tried to avoid nested 'if's as of some previous notes.

The 'resuming' two cases are handled already above so functional wise 
the code covers this.

Jason/Alex,

Please recommend what is the preferred way, both options seems to be 
fine for me.

>
> Also
>
> 	u32 flipped_bits = old_state ^ state;
>
> or similar would simplify all these cases slightly.
>

Sure, will use it in V3.

>> +
>> +	/* Saving switches on */
>> +	if (((old_state ^ state) & VFIO_DEVICE_STATE_SAVING) &&
>> +	    (state & VFIO_DEVICE_STATE_SAVING)) {
>> +		if (!(state & VFIO_DEVICE_STATE_RUNNING)) {
>> +			/* serialize post copy */
>> +			ret = mlx5vf_pci_save_device_data(mvdev);
>> +			if (ret)
>> +				return ret;
>> +		}
>> +	}
> This doesn't catch all the cases, and in fact misses the most expected
> case where userspace clears the _RUNNING bit while _SAVING is already
> enabled.  Does that mean this hasn't actually been tested with QEMU?


I run QEMU with 'x-pre-copy-dirty-page-tracking=off' as current driver 
doesn't support dirty-pages.

As so, it seems that this flow wasn't triggered by QEMU in my save/load 
test.

> It seems like there also needs to be a clause in the case where
> _RUNNING switches off to test if _SAVING is already set and has not
> toggled.
>

This can be achieved by adding the below to current code, this assumes 
that we are fine with nested 'if's coding.

Seems OK ?

@@ -269,6 +269,7 @@ static int mlx5vf_pci_set_device_state(struct 
mlx5vf_pci_core_device *mvdev,
  {
         struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
         u32 old_state = vmig->vfio_dev_state;
+       u32 flipped_bits = old_state ^ state;
         int ret = 0;

         if (old_state == VFIO_DEVICE_STATE_ERROR ||
@@ -277,7 +278,7 @@ static int mlx5vf_pci_set_device_state(struct 
mlx5vf_pci_core_device *mvdev,
                 return -EINVAL;

         /* Running switches off */
-       if (((old_state ^ state) & VFIO_DEVICE_STATE_RUNNING) &&
+       if ((flipped_bits & VFIO_DEVICE_STATE_RUNNING) &&
             (old_state & VFIO_DEVICE_STATE_RUNNING)) {
                 ret = mlx5vf_pci_quiesce_device(mvdev);
                 if (ret)
@@ -287,10 +288,18 @@ static int mlx5vf_pci_set_device_state(struct 
mlx5vf_pci_core_device *mvdev,
                         vmig->vfio_dev_state = VFIO_DEVICE_STATE_ERROR;
                         return ret;
                 }
+               if (state & VFIO_DEVICE_STATE_SAVING) {
+                       /* serialize post copy */
+                       ret = mlx5vf_pci_save_device_data(mvdev);
+                       if (ret) {
+                               vmig->vfio_dev_state = 
VFIO_DEVICE_STATE_ERROR;
+                               return ret;
+                       }
+               }
         }


Yishai
