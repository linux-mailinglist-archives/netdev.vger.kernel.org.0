Return-Path: <netdev+bounces-11919-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA797351A8
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD1751C2095A
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99557C8D4;
	Mon, 19 Jun 2023 10:11:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED90C123
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:11:46 +0000 (UTC)
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4EF19A8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 03:11:35 -0700 (PDT)
X-QQ-mid:Yeas5t1687169448t432t23233
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [122.235.139.240])
X-QQ-SSF:00400000000000F0FPF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 3586088856265510750
To: "'Zhengchao Shao'" <shaozhengchao@huawei.com>,
	<netdev@vger.kernel.org>,
	<mengyuanlou@net-swift.com>,
	<davem@davemloft.net>,
	<edumazet@google.com>,
	<kuba@kernel.org>,
	<pabeni@redhat.com>
Cc: <weiyongjun1@huawei.com>,
	<yuehaibing@huawei.com>
References: <20230619085709.104271-1-shaozhengchao@huawei.com>
In-Reply-To: <20230619085709.104271-1-shaozhengchao@huawei.com>
Subject: RE: [PATCH net-next] net: txgbe: remove unused buffer in txgbe_calc_eeprom_checksum
Date: Mon, 19 Jun 2023 18:10:47 +0800
Message-ID: <005c01d9a296$513915b0$f3ab4110$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQHNIFtJ0StorG20AUS1DtyJNHbUcK+q60gQ
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Monday, June 19, 2023 4:57 PM, Zhengchao Shao wrote:
> Half a year passed since commit 049fe5365324c ("net: txgbe: Add operations
> to interact with firmware") was submitted, the buffer in
> txgbe_calc_eeprom_checksum was not used. So remove it and the related
> branch codes.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 31 +++++++------------
>  1 file changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
> index ebc46f3be056..173437c7a55f 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
> @@ -161,33 +161,24 @@ static int txgbe_calc_eeprom_checksum(struct wx *wx, u16 *checksum)
>  {
>  	u16 *eeprom_ptrs = NULL;
>  	u32 buffer_size = 0;
> -	u16 *buffer = NULL;
>  	u16 *local_buffer;
>  	int status;
>  	u16 i;
> 
>  	wx_init_eeprom_params(wx);
> 
> -	if (!buffer) {
> -		eeprom_ptrs = kvmalloc_array(TXGBE_EEPROM_LAST_WORD, sizeof(u16),
> -					     GFP_KERNEL);
> -		if (!eeprom_ptrs)
> -			return -ENOMEM;
> -		/* Read pointer area */
> -		status = wx_read_ee_hostif_buffer(wx, 0,
> -						  TXGBE_EEPROM_LAST_WORD,
> -						  eeprom_ptrs);
> -		if (status != 0) {
> -			wx_err(wx, "Failed to read EEPROM image\n");
> -			kvfree(eeprom_ptrs);
> -			return status;
> -		}
> -		local_buffer = eeprom_ptrs;
> -	} else {
> -		if (buffer_size < TXGBE_EEPROM_LAST_WORD)
> -			return -EFAULT;
> -		local_buffer = buffer;
> +	eeprom_ptrs = kvmalloc_array(TXGBE_EEPROM_LAST_WORD, sizeof(u16),
> +				     GFP_KERNEL);
> +	if (!eeprom_ptrs)
> +		return -ENOMEM;
> +	/* Read pointer area */
> +	status = wx_read_ee_hostif_buffer(wx, 0, TXGBE_EEPROM_LAST_WORD, eeprom_ptrs);
> +	if (status != 0) {
> +		wx_err(wx, "Failed to read EEPROM image\n");
> +		kvfree(eeprom_ptrs);
> +		return status;
>  	}
> +	local_buffer = eeprom_ptrs;
> 
>  	for (i = 0; i < TXGBE_EEPROM_LAST_WORD; i++)
>  		if (i != wx->eeprom.sw_region_offset + TXGBE_EEPROM_CHECKSUM)
> --
> 2.34.1
> 

Reviewed-by: Jiawen Wu <jiawenwu@trustnetic.com>


