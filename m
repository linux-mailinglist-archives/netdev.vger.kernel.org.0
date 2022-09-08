Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571395B15CA
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 09:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiIHHi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 03:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIHHi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 03:38:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731D5B4EA9
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 00:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662622703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lNfeIss/S9NdjFZnn/7NBXn285+NBOOH2efNN52matc=;
        b=N1YfTFQ9O6vSQxLRfDwZncJca0km738FhMdCYOKl6Gh3mM3PYgV3dv1LYxGoHX02e321US
        hAqfMx2yAXKzC8pO34oKzoteYU8lZHKI4wuioKOxLYcycuNXK+Y4r0VZRcG9+cVFM2NYsu
        BjXTb+pB05YkkpYWPjJz19GcQMge4MQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-610-dlU298e5NcqXQxTEue3Rzg-1; Thu, 08 Sep 2022 03:38:22 -0400
X-MC-Unique: dlU298e5NcqXQxTEue3Rzg-1
Received: by mail-wm1-f70.google.com with SMTP id j36-20020a05600c1c2400b003a540d88677so8152676wms.1
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 00:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=lNfeIss/S9NdjFZnn/7NBXn285+NBOOH2efNN52matc=;
        b=J00hBMQncFe/i3pzshI0uBxhEvJxYv6J9Ci2Otx8aFpBA8qRxkDLjm4RKy0vsk4SAq
         7LJu1UqlFyNu1btmB6K0nPxo1pHHBbCI3wXiCJYRRpkXj2rRKChRqnyTx4gLfGHDNtFv
         BgWBXwvIMH0BaZku8N0yoDIcK5y4Jrqmv2G71AjvxkwvzBBFYoyYJVUZ3GXDv4qsk29X
         8mhTS3wzP/8axqOvd+6c9sJyBpKon4ur6C4D2YgW1MsRFR2JuMdpZTGNrtogYA5s0tm1
         avAu8Ha4g35Les9RZEcdROID6NX7saxsiX2nUyM1nZCYMmO44u9m7dO2i7HvS1QBvI1K
         a5/Q==
X-Gm-Message-State: ACgBeo13gfQn5uj3GnOBibjIXuLfc7Y4ilxITSVKYe6wIYs9hsupXV+x
        XHhfXG8nZ44Ng1FitYnxx1rwC6GV+9kkZsjPLUrRqG8Hhp7v9OyCVt5pt1VgQaQZDbFjhqXcRmD
        m0oNJy4IDrakZC8Gq
X-Received: by 2002:adf:da50:0:b0:223:a1f5:fa68 with SMTP id r16-20020adfda50000000b00223a1f5fa68mr4076315wrl.528.1662622701080;
        Thu, 08 Sep 2022 00:38:21 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4G2du1LAb1HOSymNGWkaMcWDs4SUveZWIl8JMEgjM1PZBEXAKQIfn9iCcIIZMKC20K7OViHw==
X-Received: by 2002:adf:da50:0:b0:223:a1f5:fa68 with SMTP id r16-20020adfda50000000b00223a1f5fa68mr4076299wrl.528.1662622700753;
        Thu, 08 Sep 2022 00:38:20 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-119-112.dyn.eolo.it. [146.241.119.112])
        by smtp.gmail.com with ESMTPSA id r13-20020a05600c35cd00b003a319b67f64sm7888708wmq.0.2022.09.08.00.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 00:38:20 -0700 (PDT)
Message-ID: <f1ad425c45b7e3f589409010ed0966c0676e52c3.camel@redhat.com>
Subject: Re: [PATCH net-next 02/02] net: ngbe: Check some hardware functions
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org
Cc:     jiawenwu@net-swift.com
Date:   Thu, 08 Sep 2022 09:38:19 +0200
In-Reply-To: <20220905125248.2361-1-mengyuanlou@net-swift.com>
References: <20220905125248.2361-1-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-09-05 at 20:52 +0800, Mengyuan Lou wrote:
> Check eeprom ready.
> Check whether WOL is enabled.
> Check whether the MAC is available.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   | 311 ++++++++++++++++++
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |   8 +
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  54 +++
>  3 files changed, 373 insertions(+)
> 
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
> index 20c21f99e308..f38dc47b8f32 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
> @@ -381,3 +381,314 @@ int ngbe_reset_hw(struct ngbe_hw *hw)
>  
>  	return 0;
>  }
> +
> +/**
> + *  ngbe_release_eeprom_semaphore - Release hardware semaphore
> + *  @hw: pointer to hardware structure
> + *
> + *  This function clears hardware semaphore bits.
> + **/
> +static void ngbe_release_eeprom_semaphore(struct ngbe_hw *hw)
> +{
> +	wr32m(hw, NGBE_MIS_SWSM, NGBE_MIS_SWSM_SMBI, 0);
> +	ngbe_flush(hw);
> +}
> +
> +/**
> + *  ngbe_get_eeprom_semaphore - Get hardware semaphore
> + *  @hw: pointer to hardware structure
> + *  Sets the hardware semaphores so EEPROM access can occur for bit-bang method
> + **/
> +static int ngbe_get_eeprom_semaphore(struct ngbe_hw *hw)
> +{
> +	int status = 0;
> +	u32 times = 10;
> +	u32 i;
> +	u32 swsm;
> +
> +	/* Get SMBI software semaphore between device drivers first */
> +	for (i = 0; i < times; i++) {
> +		/* If the SMBI bit is 0 when we read it, then the bit will be
> +		 * set and we have the semaphore
> +		 */
> +		status = read_poll_timeout(rd32, swsm, !(swsm & NGBE_MIS_SWSM_SMBI), 50,
> +					   20000, false, hw, NGBE_MIS_SWSM);
> +		if (!status)
> +			return 0;
> +	}
> +
> +	if (i == times) {
> +		dev_err(ngbe_hw_to_dev(hw),
> +			"Driver can't access the Eeprom - SMBI Semaphore not granted.\n");
> +		/* this release is particularly important because our attempts
> +		 * above to get the semaphore may have succeeded, and if there
> +		 * was a timeout, we should unconditionally clear the semaphore
> +		 * bits to free the driver to make progress
> +		 */
> +		ngbe_release_eeprom_semaphore(hw);

If I read correctly, the firmware is setting/clearing the semaphore bit
to avoid conflicts with the kernel/driver code. I'm wondering if the
above clear would inconditionally mark the semaphore as free even if
the firmware is still holding it? (causing later bugs, hard to track).

It's not clear to me why such clear is needed.

If the later test will succeed, the driver will emit an error and will
acquire the semaphore successfully, and that will be most confusing.

> +		status = -EBUSY;
> +	}
> +	/* one last try
> +	 * If the SMBI bit is 0 when we read it, then the bit will be
> +	 * set and we have the semaphore
> +	 */
> +	swsm = rd32(hw, NGBE_MIS_SWSM);
> +	if (!(swsm & NGBE_MIS_SWSM_SMBI))
> +		status = 0;
> +	return status;
> +}
> +
> +/**
> + *  ngbe_acquire_swfw_sync - Acquire SWFW semaphore
> + *  @hw: pointer to hardware structure
> + *  @mask: Mask to specify which semaphore to acquire
> + *
> + *  Acquires the SWFW semaphore through the GSSR register for the specified
> + *  function (CSR, PHY0, PHY1, EEPROM, Flash)
> + **/
> +static int ngbe_acquire_swfw_sync(struct ngbe_hw *hw, u32 mask)
> +{
> +	u32 gssr = 0;
> +	u32 swmask = mask;
> +	u32 fwmask = mask << 16;
> +	u32 times = 2000;
> +	u32 i;

Please respect the reverse x-mas tree declaration order. Other
instances later and in the previous patch.

> +
> +	for (i = 0; i < times; i++) {
> +		/* SW NVM semaphore bit is used for access to all
> +		 * SW_FW_SYNC bits (not just NVM)
> +		 */
> +		if (ngbe_get_eeprom_semaphore(hw))
> +			return -EBUSY;
> +
> +		gssr = rd32(hw, NGBE_MNG_SWFW_SYNC);
> +		if (!(gssr & (fwmask | swmask))) {
> +			gssr |= swmask;
> +			wr32(hw, NGBE_MNG_SWFW_SYNC, gssr);
> +			ngbe_release_eeprom_semaphore(hw);
> +			return 0;
> +		}
> +		/* Resource is currently in use by FW or SW */
> +		ngbe_release_eeprom_semaphore(hw);
> +	}
> +
> +	/* If time expired clear the bits holding the lock and retry */
> +	if (gssr & (fwmask | swmask))
> +		ngbe_release_swfw_sync(hw, gssr & (fwmask | swmask));
> +
> +	return -EBUSY;
> +}
> +
> +/**
> + *  ngbe_release_swfw_sync - Release SWFW semaphore
> + *  @hw: pointer to hardware structure
> + *  @mask: Mask to specify which semaphore to release
> + *
> + *  Releases the SWFW semaphore through the GSSR register for the specified
> + *  function (CSR, PHY0, PHY1, EEPROM, Flash)
> + **/
> +void ngbe_release_swfw_sync(struct ngbe_hw *hw, u32 mask)
> +{
> +	ngbe_get_eeprom_semaphore(hw);

Why can't ngbe_get_eeprom_semaphore() fail here? 

> +	wr32m(hw, NGBE_MNG_SWFW_SYNC, mask, 0);
> +	ngbe_release_eeprom_semaphore(hw);
> +}
> +
> +/**
> + *  ngbe_host_interface_command - Issue command to manageability block
> + *  @hw: pointer to the HW structure
> + *  @buffer: contains the command to write and where the return status will
> + *   be placed
> + *  @length: length of buffer, must be multiple of 4 bytes
> + *  @timeout: time in ms to wait for command completion
> + *  @return_data: read and return data from the buffer (true) or not (false)
> + *   Needed because FW structures are big endian and decoding of
> + *   these fields can be 8 bit or 16 bit based on command. Decoding
> + *   is not easily understood without making a table of commands.
> + *   So we will leave this up to the caller to read back the data
> + *   in these cases.
> + **/
> +int ngbe_host_interface_command(struct ngbe_hw *hw, u32 *buffer,
> +				u32 length, u32 timeout, bool return_data)
> +{
> +	u32 hicr, i, bi;
> +	u32 hdr_size = sizeof(struct ngbe_hic_hdr);
> +	u16 buf_len;
> +	u32 dword_len;
> +	int err = 0;
> +	u32 buf[64] = {};
> +
> +	if (length == 0 || length > NGBE_HI_MAX_BLOCK_BYTE_LENGTH) {
> +		dev_err(ngbe_hw_to_dev(hw),
> +			"Buffer length failure buffersize=%d.\n", length);
> +		return -EINVAL;
> +	}
> +
> +	if (ngbe_acquire_swfw_sync(hw, NGBE_MNG_SWFW_SYNC_SW_MB) != 0)
> +		return -EBUSY;
> +
> +	/* Calculate length in DWORDs. We must be DWORD aligned */
> +	if ((length % (sizeof(u32))) != 0) {
> +		dev_err(ngbe_hw_to_dev(hw),
> +			"Buffer length failure, not aligned to dword");
> +		err = -EINVAL;
> +		goto rel_out;
> +	}
> +
> +	/*read to clean all status*/
> +	hicr = rd32(hw, NGBE_MNG_MBOX_CTL);
> +	if ((hicr & NGBE_MNG_MBOX_CTL_FWRDY))
> +		dev_err(ngbe_hw_to_dev(hw),
> +			"fwrdy is set before command.\n");
> +	dword_len = length >> 2;
> +	/* The device driver writes the relevant command block
> +	 * into the ram area.
> +	 */
> +	for (i = 0; i < dword_len; i++)
> +		wr32a(hw, NGBE_MNG_MBOX, i, buffer[i]);
> +
> +	/* Setting this bit tells the ARC that a new command is pending. */
> +	wr32m(hw, NGBE_MNG_MBOX_CTL,
> +	      NGBE_MNG_MBOX_CTL_SWRDY, NGBE_MNG_MBOX_CTL_SWRDY);
> +
> +	for (i = 0; i < timeout; i++) {
> +		err = read_poll_timeout(rd32, hicr, hicr & NGBE_MNG_MBOX_CTL_FWRDY, 1000,
> +					20000, false, hw, NGBE_MNG_MBOX_CTL);
> +		if (!err)
> +			break;
> +	}
> +
> +	buf[0] = rd32(hw, NGBE_MNG_MBOX);
> +	/* Check command completion */
> +	if (timeout != 0 && i == timeout) {
> +		dev_err(ngbe_hw_to_dev(hw),
> +			"Command has failed with no status valid.\n");
> +		if ((buffer[0] & 0xff) != (~buf[0] >> 24)) {
> +			err = -EINVAL;
> +			goto rel_out;
> +		}
> +	}
> +
> +	if (!return_data)
> +		goto rel_out;
> +
> +	/* Calculate length in DWORDs */
> +	dword_len = hdr_size >> 2;
> +
> +	/* first pull in the header so we know the buffer length */
> +	for (bi = 0; bi < dword_len; bi++)
> +		buffer[bi] = rd32a(hw, NGBE_MNG_MBOX, bi);
> +
> +	/* If there is any thing in data position pull it in */
> +	buf_len = ((struct ngbe_hic_hdr *)buffer)->buf_len;
> +	if (buf_len == 0)
> +		goto rel_out;
> +
> +	if (length < buf_len + hdr_size) {
> +		dev_err(ngbe_hw_to_dev(hw),
> +			"Buffer not large enough for reply message.\n");
> +		err = -ENOMEM;
> +		goto rel_out;
> +	}
> +
> +	/* Calculate length in DWORDs, add 3 for odd lengths */
> +	dword_len = (buf_len + 3) >> 2;
> +
> +	/* Pull in the rest of the buffer (bi is where we left off) */
> +	for (; bi <= dword_len; bi++)
> +		buffer[bi] = rd32a(hw, NGBE_MNG_MBOX, bi);
> +
> +rel_out:
> +	ngbe_release_swfw_sync(hw, NGBE_MNG_SWFW_SYNC_SW_MB);
> +	return err;
> +}
> +
> +/**
> + *  ngbe_init_eeprom_params - Initialize EEPROM params
> + *  @hw: pointer to hardware structure
> + *
> + *  Initializes the EEPROM parameters ngbe_eeprom_info within the
> + *  ngbe_hw struct in order to set up EEPROM access.
> + **/
> +void ngbe_init_eeprom_params(struct ngbe_hw *hw)
> +{
> +	struct ngbe_eeprom_info *eeprom = &hw->eeprom;
> +
> +	eeprom->semaphore_delay = 10;
> +	eeprom->word_size = 1024 >> 1;
> +	eeprom->sw_region_offset = 0x80;
> +}
> +
> +int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw)
> +{
> +	int tmp;
> +	int status;
> +	struct ngbe_hic_read_shadow_ram buffer;
> +
> +	buffer.hdr.req.cmd = NGBE_FW_EEPROM_CHECKSUM_CMD;
> +	buffer.hdr.req.buf_lenh = 0;
> +	buffer.hdr.req.buf_lenl = 0;
> +	buffer.hdr.req.checksum = NGBE_FW_CMD_DEFAULT_CHECKSUM;
> +	/* convert offset from words to bytes */
> +	buffer.address = 0;
> +	/* one word */
> +	buffer.length = 0;
> +
> +	status = ngbe_host_interface_command(hw, (u32 *)&buffer,
> +					     sizeof(buffer),
> +					     NGBE_HI_COMMAND_TIMEOUT, false);
> +
> +	if (status < 0)
> +		return status;
> +	tmp = (u32)rd32a(hw, NGBE_MNG_MBOX, 1);

If you declare tmp as u32 the above cast will be needed, also a more
meaningful variable name would help

> +	if (tmp == 0x80658383)

Why this magic mumber? perhaps you can define/use some driver constant.

> +		status = 0;

or just:
		return 0;
	return -EIO;

unless you plan to touch this code path with later patches.

> +	else
> +		return -EIO;
> +
> +	return status;
> +}
> +
> +static int ngbe_read_ee_hostif_data32(struct ngbe_hw *hw, u16 offset, u32 *data)
> +{
> +	int status;
> +	struct ngbe_hic_read_shadow_ram buffer;
> +
> +	buffer.hdr.req.cmd = NGBE_FW_READ_SHADOW_RAM_CMD;
> +	buffer.hdr.req.buf_lenh = 0;
> +	buffer.hdr.req.buf_lenl = NGBE_FW_READ_SHADOW_RAM_LEN;
> +	buffer.hdr.req.checksum = NGBE_FW_CMD_DEFAULT_CHECKSUM;
> +	/* convert offset from words to bytes */
> +	buffer.address = (__force u32)cpu_to_be32(offset * 2);
> +	/* one word */
> +	buffer.length = (__force u16)cpu_to_be16(sizeof(u32));
> +
> +	status = ngbe_host_interface_command(hw, (u32 *)&buffer,
> +					     sizeof(buffer),
> +					     NGBE_HI_COMMAND_TIMEOUT, false);
> +	if (status)
> +		return status;
> +	*data = (u32)rd32a(hw, NGBE_MNG_MBOX, NGBE_FW_NVM_DATA_OFFSET);

Cast likely not needed.


Cheers,

Paolo

