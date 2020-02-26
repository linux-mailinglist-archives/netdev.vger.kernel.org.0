Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0CA6170C98
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 00:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgBZXcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 18:32:39 -0500
Received: from mga18.intel.com ([134.134.136.126]:21925 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgBZXci (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 18:32:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Feb 2020 15:32:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,489,1574150400"; 
   d="scan'208";a="350511839"
Received: from sneftin-mobl1.ger.corp.intel.com (HELO [10.24.14.90]) ([10.24.14.90])
  by fmsmga001.fm.intel.com with ESMTP; 26 Feb 2020 15:32:37 -0800
Subject: Re: [Intel-wired-lan] [PATCH next] igc: make non-global functions
 static
To:     Chen Zhou <chenzhou10@huawei.com>, jeffrey.t.kirsher@intel.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20200108133959.93035-1-chenzhou10@huawei.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <1453037a-4370-8c08-f8c9-dfaa629e96b0@intel.com>
Date:   Wed, 26 Feb 2020 15:32:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200108133959.93035-1-chenzhou10@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/2020 05:39, Chen Zhou wrote:
> Fix sparse warning:
> drivers/net/ethernet/intel/igc/igc_ptp.c:512:6:
> 	warning: symbol 'igc_ptp_tx_work' was not declared. Should it be static?
> drivers/net/ethernet/intel/igc/igc_ptp.c:644:6:
> 	warning: symbol 'igc_ptp_suspend' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_ptp.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
> index 6935065..389a969 100644
> --- a/drivers/net/ethernet/intel/igc/igc_ptp.c
> +++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
> @@ -509,7 +509,7 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
>    * This work function polls the TSYNCTXCTL valid bit to determine when a
>    * timestamp has been taken for the current stored skb.
>    */
> -void igc_ptp_tx_work(struct work_struct *work)
> +static void igc_ptp_tx_work(struct work_struct *work)
>   {
>   	struct igc_adapter *adapter = container_of(work, struct igc_adapter,
>   						   ptp_tx_work);
> @@ -641,7 +641,7 @@ void igc_ptp_init(struct igc_adapter *adapter)
>    * This function stops the overflow check work and PTP Tx timestamp work, and
>    * will prepare the device for OS suspend.
>    */
> -void igc_ptp_suspend(struct igc_adapter *adapter)
> +static void igc_ptp_suspend(struct igc_adapter *adapter)
>   {
>   	if (!(adapter->ptp_flags & IGC_PTP_ENABLED))
>   		return;
> 
This patch should be partially reverted for "igc_ptp_suspend".
"igc_ptp_suspend" declared in igc.h file and used in "__igc_shutdown" 
method.
