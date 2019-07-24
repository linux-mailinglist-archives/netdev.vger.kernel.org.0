Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9DB973422
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbfGXQpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:45:13 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:34050 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726997AbfGXQpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 12:45:12 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id ACD5CB40071;
        Wed, 24 Jul 2019 16:45:10 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 24 Jul
 2019 09:44:59 -0700
Subject: Re: [PATCH net-next 03/10] sfc: Use dev_get_drvdata where possible
To:     Chuhong Yuan <hslester96@gmail.com>
CC:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "Martin Habets" <mhabets@solarflare.com>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190724112658.13241-1-hslester96@gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <0fb1dc63-0dce-dfeb-ef74-7883a7b63538@solarflare.com>
Date:   Wed, 24 Jul 2019 17:44:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190724112658.13241-1-hslester96@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24792.002
X-TM-AS-Result: No-9.411600-4.000000-10
X-TMASE-MatchedRID: zGP2F0O7j/s6yy6RAAEPc78kYs0sFfJn69aS+7/zbj+qvcIF1TcLYMiT
        Wug2C4DNl1M7KT9/aqA65JDztUKj+SHhSBQfglfsA9lly13c/gHYuVu0X/rOkMAkyHiYDAQb+9R
        qUr/gzAy2ElsrxSFwyOw7fJE49lGn1Lt7MpzUCiTF30Jee57vxg+jS+LRpl81iiKPXbEds+5owd
        s9EtnpIuLxYrk8G4y1kZOl7WKIImrvXOvQVlExsFZ0V5tYhzdWxEHRux+uk8geb2CAVWgJwCnW6
        Vd+hzzp4q2OQB0NF5ugw7WrK1XGkTjxgahWxB1n0SvbaTk+J3J+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.411600-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24792.002
X-MDID: 1563986711-iSl_NlxktAMj
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/07/2019 12:26, Chuhong Yuan wrote:
> Instead of using to_pci_dev + pci_get_drvdata,
> use dev_get_drvdata to make code simpler.
>
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Acked-by: Edward Cree <ecree@solarflare.com>

> ---
>  drivers/net/ethernet/sfc/ef10.c |  4 ++--
>  drivers/net/ethernet/sfc/efx.c  | 10 +++++-----
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index 16d6952c312a..0ec13f520e90 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -508,7 +508,7 @@ static ssize_t efx_ef10_show_link_control_flag(struct device *dev,
>  					       struct device_attribute *attr,
>  					       char *buf)
>  {
> -	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
> +	struct efx_nic *efx = dev_get_drvdata(dev);
>  
>  	return sprintf(buf, "%d\n",
>  		       ((efx->mcdi->fn_flags) &
> @@ -520,7 +520,7 @@ static ssize_t efx_ef10_show_primary_flag(struct device *dev,
>  					  struct device_attribute *attr,
>  					  char *buf)
>  {
> -	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
> +	struct efx_nic *efx = dev_get_drvdata(dev);
>  
>  	return sprintf(buf, "%d\n",
>  		       ((efx->mcdi->fn_flags) &
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index ab58b837df47..2fef7402233e 100644
> --- a/drivers/net/ethernet/sfc/efx.c
> +++ b/drivers/net/ethernet/sfc/efx.c
> @@ -2517,7 +2517,7 @@ static struct notifier_block efx_netdev_notifier = {
>  static ssize_t
>  show_phy_type(struct device *dev, struct device_attribute *attr, char *buf)
>  {
> -	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
> +	struct efx_nic *efx = dev_get_drvdata(dev);
>  	return sprintf(buf, "%d\n", efx->phy_type);
>  }
>  static DEVICE_ATTR(phy_type, 0444, show_phy_type, NULL);
> @@ -2526,7 +2526,7 @@ static DEVICE_ATTR(phy_type, 0444, show_phy_type, NULL);
>  static ssize_t show_mcdi_log(struct device *dev, struct device_attribute *attr,
>  			     char *buf)
>  {
> -	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
> +	struct efx_nic *efx = dev_get_drvdata(dev);
>  	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
>  
>  	return scnprintf(buf, PAGE_SIZE, "%d\n", mcdi->logging_enabled);
> @@ -2534,7 +2534,7 @@ static ssize_t show_mcdi_log(struct device *dev, struct device_attribute *attr,
>  static ssize_t set_mcdi_log(struct device *dev, struct device_attribute *attr,
>  			    const char *buf, size_t count)
>  {
> -	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
> +	struct efx_nic *efx = dev_get_drvdata(dev);
>  	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
>  	bool enable = count > 0 && *buf != '0';
>  
> @@ -3654,7 +3654,7 @@ static int efx_pci_sriov_configure(struct pci_dev *dev, int num_vfs)
>  
>  static int efx_pm_freeze(struct device *dev)
>  {
> -	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
> +	struct efx_nic *efx = dev_get_drvdata(dev);
>  
>  	rtnl_lock();
>  
> @@ -3675,7 +3675,7 @@ static int efx_pm_freeze(struct device *dev)
>  static int efx_pm_thaw(struct device *dev)
>  {
>  	int rc;
> -	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
> +	struct efx_nic *efx = dev_get_drvdata(dev);
>  
>  	rtnl_lock();
>  

