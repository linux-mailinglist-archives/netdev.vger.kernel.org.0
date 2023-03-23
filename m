Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1166C631C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 10:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjCWJSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 05:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjCWJSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 05:18:32 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2076.outbound.protection.outlook.com [40.107.96.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679DEC1;
        Thu, 23 Mar 2023 02:18:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZHVuTLTU+0Xd+rJ5afSrDVaYR7UvsKcDItVJaSZrpFeNjwPiEadTKt0aZlsREQWyRHxBmVTHITgOlE+GAlN487vO8jq0ftnRZ1wA0QLwGyqc8QJYflKCXKMWSHjI+Vm6eJxo14+IjI9sa4RqKeIVkSGHlbVpXgYo3e1egGy9pd/EKgxZN8l5+jiW6hQzGy7AAR5bH+o0L3E0KIceVqnOz98ynO0XHwW9sCUBrA0tXqw362HkYMMQsVg3cIkYlkPOJXq3d0BzmahlmfPIrtOE/I3BeqGkafxewPwv0HJuzRpudVIo2NKAT+0Hju1MawjOZlXVjeJpShS5ZWk0Pk+wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUwkkgJ97zyVav2tbev6cqrKREvSS9MCKUzVAdZ3vnA=;
 b=nfoZRBaOslsozZT/aONZ3Va1H6R+Fsf/88WQZn435f91SkjDBRglZaT6h7LQDMO/b9o1Ag5lHhbI+fy0HqPwyD7Wa5J3plPAS+M8d8LPnCxOQGgaWELlZrHq1xca/C5KeZDYlruFjA7W/uLlbrA3O6l5n4d3RHuSiW+Bdm8Hx+eCC1rMY1LLkNGit+eRLy5JPsX/4QLUG9w/YH4cwpFmEAlBxlseEFcPLuLxLPp0Eaq/g54PDbuA7j7hrGXp/IwaQ04NfkqNO1OQFfK4b1bMKq/owiLksBb64ggw4i880ZC0WK3bjia4aT4R35/HmQsJatu7kKAqyGLYggVn34vRHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUwkkgJ97zyVav2tbev6cqrKREvSS9MCKUzVAdZ3vnA=;
 b=E8aIenuvbhNxsOeJWvcvvd/w6pPK7zja3jErUM5iUx2rn9KCRkfp65nluQw0upGzocTxODHNayiWxcnrRu4MhjEmut52BihxPITooblr/hIxR/YrkxAQ1wX2f0gHH7+bbUbxRX60Ndg0hsaqehMd8sOUoBv7XU7pIDTD8F0ELNQSKUrxuJSoECrxMwpwrB4ffYTcozLs3BVEhx5VJrvJflkfTmyMXmx6UxkXq6d4YRVdzi/tAFhHeslMWDrUj2RM/EFa/uK06fwUhV5HtZwINBjOWjtlHnLlhgaPdEmsVLR3J519mJC1jevNYrlvlLoFM4iCj0jLop4h7blVbQlhsw==
Received: from DS7P222CA0015.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::27) by
 PH8PR12MB6963.namprd12.prod.outlook.com (2603:10b6:510:1be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 09:18:28 +0000
Received: from DS1PEPF0000E63F.namprd02.prod.outlook.com
 (2603:10b6:8:2e:cafe::e7) by DS7P222CA0015.outlook.office365.com
 (2603:10b6:8:2e::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 09:18:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E63F.mail.protection.outlook.com (10.167.17.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 23 Mar 2023 09:18:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 23 Mar 2023
 02:18:15 -0700
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 23 Mar
 2023 02:18:12 -0700
References: <cover.1679502371.git.petrm@nvidia.com>
 <c61d07469ecf5d3053442e24d4d050405f466b76.1679502371.git.petrm@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, <mlxsw@nvidia.com>,
        <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH net-next 6/6] mlxsw: pci: Add support for new reset flow
Date:   Thu, 23 Mar 2023 10:13:41 +0100
In-Reply-To: <c61d07469ecf5d3053442e24d4d050405f466b76.1679502371.git.petrm@nvidia.com>
Message-ID: <87cz4zq10u.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E63F:EE_|PH8PR12MB6963:EE_
X-MS-Office365-Filtering-Correlation-Id: bf10dc37-0e9a-432a-e219-08db2b7f9023
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zqiv79CW6lylKXrzwKDxhgx3q4aBBFyUXT0/bGLt6BW1VSp5Xqm4RIJikZgv+sg2L3L6M54Cej91q2kJn2wxenEmqR+fTgrrEzs8Ukg1XNRhFPNLyyigYT77jypmQa7mK8lHI7KTlW9t9CsGdMLOhLU1bOaismx0LQzuMVge7nDXm2id4Km+8uQfq9T4tDwVqtD5L/z6adcLS+eXcJvcAVArTv15hqcwsCe6l/LlLZQbGllJAoqa6Qs3bZcdeKGJ3j7hi7BUTS24qpcztWS9bG3dfLc56UjxCfHkGxu+Fib/Kd4Yq6F+LIAMOKlWZH9IcleLeT1YKUyZNUZ8wnpGbxTUEmGw4/64qa0LrgomVuj4TlvgW2RwM0II/zxI8atW3Nzw+ibwXDnIlPyyjs1/U8HTthTLZBk6VidkV3DhAMeGAFW34fGPLTkzqKNBQ5eMa9q3K52cvpuxKk20ae15xwE1FPFoM8kJtAIbxivaYf4qgddZw4upu2/fsjYCPIdqj45iKvFcqxI5MTLqQWx21p1CFHCxZ1DZGib4nuppzmrpKrqrzvbLKL57J7jj4nNVPaA/CqlY4Ufam8Ei26TQajixlXSTwtS3wHG1uJSq+8Qt+ayx5xPuuM4MwqW2h7xKIGVXEMbmR/gP1igtwKRMvlNlo7/n4B0Kac6KKmk//FGt2JiJhHUKWxGoJ92YFSkcX6KKOG7Iv+SdT/7KzxSnrXFI7Ub3ghBtSXrP0CZHHOk2TFLQoKle+OzcJGx6ltRF
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199018)(46966006)(40470700004)(36840700001)(16526019)(186003)(2616005)(6666004)(356005)(336012)(26005)(6200100001)(86362001)(426003)(47076005)(54906003)(7636003)(478600001)(40460700003)(82740400003)(2906002)(45080400002)(83380400001)(8676002)(82310400005)(6862004)(316002)(8936002)(41300700001)(40480700001)(37006003)(70586007)(70206006)(36756003)(5660300002)(4326008)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 09:18:28.0606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf10dc37-0e9a-432a-e219-08db2b7f9023
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E63F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6963
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> From: Amit Cohen <amcohen@nvidia.com>
>
> The driver resets the device during probe and during a devlink reload.
> The current reset method reloads the current firmware version or a pending
> one, if one was previously flashed using devlink. However, the reset does
> not take down the PCI link, preventing the PCI firmware from being
> upgraded, unless the system is rebooted.
>
> To solve this problem, a new reset command (6) was implemented in the
> firmware. Unlike the current command (1), after issuing the new command
> the device will not start the reset immediately, but only after the PCI
> link was disabled. The driver is expected to wait for 500ms before
> re-enabling the link to give the firmware enough time to start the reset.
>
> Implement the new reset method and use it only after verifying it is
> supported by the current firmware version by querying the Management
> Capabilities Mask (MCAM) register. Consider the PCI firmware to be
> operational either after waiting for a predefined time of 2000ms or after
> reading an active link status when "Data Link Layer Link Active Reporting"
> is supported. For good measures, make sure the device ID can be read from
> the configuration space of the device.
>
> Once the PCI firmware is operational, go back to the regular reset flow
> and wait for the entire device to become ready. That is, repeatedly read
> the "system_status" register from the BAR until a value of "FW_READY"
> (0x5E) appears.
>
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

What I forgot to do was to CC PCI maintainer / subsystem. None of us in
the mlxsw team is well versed in PCI odds and ends, and we would
appreciate a sanity check of this code.

> ---
>  drivers/net/ethernet/mellanox/mlxsw/pci.c    | 151 ++++++++++++++++++-
>  drivers/net/ethernet/mellanox/mlxsw/pci_hw.h |   5 +
>  2 files changed, 155 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
> index 73ae2fdd94c4..9b11c5280424 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
> @@ -1459,6 +1459,137 @@ static int mlxsw_pci_sys_ready_wait(struct mlxsw_pci *mlxsw_pci,
>  	return -EBUSY;
>  }
>  
> +static int mlxsw_pci_link_active_wait(struct pci_dev *pdev)
> +{
> +	unsigned long end;
> +	u16 lnksta;
> +	int err;
> +
> +	end = jiffies + msecs_to_jiffies(MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
> +	do {
> +		msleep(MLXSW_PCI_TOGGLE_WAIT_MSECS);
> +		err = pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
> +		if (err)
> +			return pcibios_err_to_errno(err);
> +
> +		if (lnksta & PCI_EXP_LNKSTA_DLLLA)
> +			return 0;
> +	} while (time_before(jiffies, end));
> +
> +	pci_err(pdev, "PCI link not ready (0x%04x) after %d ms\n", lnksta,
> +		MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int mlxsw_pci_link_active_check(struct pci_dev *pdev)
> +{
> +	u32 lnkcap;
> +	int err;
> +
> +	err = pcie_capability_read_dword(pdev, PCI_EXP_LNKCAP, &lnkcap);
> +	if (err)
> +		goto out;
> +
> +	if (lnkcap & PCI_EXP_LNKCAP_DLLLARC)
> +		return mlxsw_pci_link_active_wait(pdev);
> +
> +	/* In case the device does not support "Data Link Layer Link Active
> +	 * Reporting", simply wait for a predefined time for the device to
> +	 * become active.
> +	 */
> +	pci_dbg(pdev, "No PCI link reporting capability (0x%08x)\n", lnkcap);
> +
> +out:
> +	/* Sleep before handling the rest of the flow and accessing to PCI. */
> +	msleep(MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
> +	return pcibios_err_to_errno(err);
> +}
> +
> +static int mlxsw_pci_link_toggle(struct pci_dev *pdev)
> +{
> +	int err;
> +
> +	/* Disable the link. */
> +	err = pcie_capability_set_word(pdev, PCI_EXP_LNKCTL, PCI_EXP_LNKCTL_LD);
> +	if (err)
> +		return pcibios_err_to_errno(err);
> +
> +	/* Sleep to give firmware enough time to start the reset. */
> +	msleep(MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS);
> +
> +	/* Enable the link. */
> +	err = pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL,
> +					 PCI_EXP_LNKCTL_LD);
> +	if (err)
> +		return pcibios_err_to_errno(err);
> +
> +	/* Wait for link active. */
> +	return mlxsw_pci_link_active_check(pdev);
> +}
> +
> +static int mlxsw_pci_device_id_read(struct pci_dev *pdev, u16 exp_dev_id)
> +{
> +	unsigned long end;
> +	u16 dev_id;
> +	int err;
> +
> +	end = jiffies + msecs_to_jiffies(MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
> +	do {
> +		msleep(MLXSW_PCI_TOGGLE_WAIT_MSECS);
> +
> +		/* Expect to get the correct PCI device ID as first indication
> +		 * that the ASIC is available.
> +		 */
> +		err = pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
> +		if (err)
> +			return pcibios_err_to_errno(err);
> +
> +		if (dev_id == exp_dev_id)
> +			return 0;
> +	} while (time_before(jiffies, end));
> +
> +	pci_err(pdev, "PCI device ID is not as expected after %d ms\n",
> +		MLXSW_PCI_TOGGLE_TIMEOUT_MSECS);
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int mlxsw_pci_reset_at_pci_disable(struct mlxsw_pci *mlxsw_pci)
> +{
> +	struct pci_bus *bridge_bus = mlxsw_pci->pdev->bus;
> +	struct pci_dev *bridge_pdev = bridge_bus->self;
> +	struct pci_dev *pdev = mlxsw_pci->pdev;
> +	char mrsr_pl[MLXSW_REG_MRSR_LEN];
> +	u16 dev_id = pdev->device;
> +	int err;
> +
> +	mlxsw_reg_mrsr_pack(mrsr_pl,
> +			    MLXSW_REG_MRSR_COMMAND_RESET_AT_PCI_DISABLE);
> +	err = mlxsw_reg_write(mlxsw_pci->core, MLXSW_REG(mrsr), mrsr_pl);
> +	if (err)
> +		return err;
> +
> +	/* Save the PCI configuration space so that we will be able to restore
> +	 * it after the firmware was reset.
> +	 */
> +	pci_save_state(pdev);
> +	pci_cfg_access_lock(pdev);
> +
> +	err = mlxsw_pci_link_toggle(bridge_pdev);
> +	if (err) {
> +		pci_err(bridge_pdev, "Failed to toggle PCI link\n");
> +		goto restore;
> +	}
> +
> +	err = mlxsw_pci_device_id_read(pdev, dev_id);
> +
> +restore:
> +	pci_cfg_access_unlock(pdev);
> +	pci_restore_state(pdev);
> +	return err;
> +}
> +
>  static int mlxsw_pci_reset_sw(struct mlxsw_pci *mlxsw_pci)
>  {
>  	char mrsr_pl[MLXSW_REG_MRSR_LEN];
> @@ -1471,6 +1602,8 @@ static int
>  mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
>  {
>  	struct pci_dev *pdev = mlxsw_pci->pdev;
> +	char mcam_pl[MLXSW_REG_MCAM_LEN];
> +	bool pci_reset_supported;
>  	u32 sys_status;
>  	int err;
>  
> @@ -1481,7 +1614,23 @@ mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
>  		return err;
>  	}
>  
> -	err = mlxsw_pci_reset_sw(mlxsw_pci);
> +	mlxsw_reg_mcam_pack(mcam_pl,
> +			    MLXSW_REG_MCAM_FEATURE_GROUP_ENHANCED_FEATURES);
> +	err = mlxsw_reg_query(mlxsw_pci->core, MLXSW_REG(mcam), mcam_pl);
> +	if (err)
> +		return err;
> +
> +	mlxsw_reg_mcam_unpack(mcam_pl, MLXSW_REG_MCAM_PCI_RESET,
> +			      &pci_reset_supported);
> +
> +	if (pci_reset_supported) {
> +		pci_dbg(pdev, "Starting PCI reset flow\n");
> +		err = mlxsw_pci_reset_at_pci_disable(mlxsw_pci);
> +	} else {
> +		pci_dbg(pdev, "Starting software reset flow\n");
> +		err = mlxsw_pci_reset_sw(mlxsw_pci);
> +	}
> +
>  	if (err)
>  		return err;
>  
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
> index 48dbfea0a2a1..ded0828d7f1f 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
> +++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
> @@ -27,6 +27,11 @@
>  
>  #define MLXSW_PCI_SW_RESET_TIMEOUT_MSECS	900000
>  #define MLXSW_PCI_SW_RESET_WAIT_MSECS		200
> +
> +#define MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS	500
> +#define MLXSW_PCI_TOGGLE_WAIT_MSECS		20
> +#define MLXSW_PCI_TOGGLE_TIMEOUT_MSECS		2000
> +
>  #define MLXSW_PCI_FW_READY			0xA1844
>  #define MLXSW_PCI_FW_READY_MASK			0xFFFF
>  #define MLXSW_PCI_FW_READY_MAGIC		0x5E

