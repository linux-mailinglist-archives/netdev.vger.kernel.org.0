Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FFB29A21F
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 02:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503727AbgJ0BTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 21:19:07 -0400
Received: from z5.mailgun.us ([104.130.96.5]:57274 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439552AbgJ0BTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 21:19:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603761545; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=ykRa/SRdEbudabccJMxxWepehMTr63NuIg68ElZPYA8=; b=L/0DPWpjBRb1u6CfUkpf9iK0Se2CCl9Cxg//ZJAsUn2lValpRARsy42bwYPcVREk+8RsoPhu
 7KUaMngC0P5myhMTo0f39ZAZUe38UnB6g9/JT9R6RghXfqf1WngGxxLQf1Pri3nveIzJQYJQ
 WBe25A0Jgh0SIFqBNVl7b4NsBL0=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5f97758401bdd11b7948cab0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 27 Oct 2020 01:19:00
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3DB17C433CB; Tue, 27 Oct 2020 01:18:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 30096C433C9;
        Tue, 27 Oct 2020 01:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 30096C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v9 4/4] bus: mhi: Add userspace client interface driver
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>, netdev@vger.kernel.org
References: <1603495075-11462-1-git-send-email-hemantk@codeaurora.org>
 <1603495075-11462-5-git-send-email-hemantk@codeaurora.org>
 <CAMZdPi_MQ0SqK7s6h_1_9yEDD0vuAOpCTjSHTd1PBsGjvXukiA@mail.gmail.com>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <aefee6d1-da2c-d081-6bda-b9bd49e8c12f@codeaurora.org>
Date:   Mon, 26 Oct 2020 18:18:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAMZdPi_MQ0SqK7s6h_1_9yEDD0vuAOpCTjSHTd1PBsGjvXukiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On 10/26/20 10:34 AM, Loic Poulain wrote:
> Hi Hemant,
> 
> That looks better IMHO, just small comments on locking.
> 
[..]
>     +static ssize_t mhi_uci_write(struct file *file,
>     +                            const char __user *buf,
>     +                            size_t count,
>     +                            loff_t *offp)
>     +{
>     +       struct uci_dev *udev = file->private_data;
>     +       struct mhi_device *mhi_dev = udev->mhi_dev;
>     +       struct device *dev = &mhi_dev->dev;
>     +       struct uci_chan *uchan = udev->uchan;
>     +       size_t bytes_xfered = 0;
>     +       int ret, nr_avail = 0;
>     +
>     +       /* if ul channel is not supported return error */
>     +       if (!buf || !count || !mhi_dev->ul_chan)
>     +               return -EINVAL;
>     +
>     +       dev_dbg(dev, "%s: to xfer: %zu bytes\n", __func__, count);
>     +
>     +       mutex_lock(&uchan->write_lock);
> 
> 
> Maybe mutex_lock_interruptible is more appropriate here (same in read fops).
i agree, will return -EINTR if mutex_lock_interruptible returns < 0.
> 
[..]
>     +static ssize_t mhi_uci_read(struct file *file,
>     +                           char __user *buf,
>     +                           size_t count,
>     +                           loff_t *ppos)
>     +{
>     +       struct uci_dev *udev = file->private_data;
>     +       struct mhi_device *mhi_dev = udev->mhi_dev;
>     +       struct uci_chan *uchan = udev->uchan;
>     +       struct device *dev = &mhi_dev->dev;
>     +       struct uci_buf *ubuf;
>     +       size_t rx_buf_size;
>     +       char *ptr;
>     +       size_t to_copy;
>     +       int ret = 0;
>     +
>     +       /* if dl channel is not supported return error */
>     +       if (!buf || !mhi_dev->dl_chan)
>     +               return -EINVAL;
>     +
>     +       mutex_lock(&uchan->read_lock);
>     +       spin_lock_bh(&uchan->dl_pending_lock);
>     +       /* No data available to read, wait */
>     +       if (!uchan->cur_buf && list_empty(&uchan->dl_pending)) {
>     +               dev_dbg(dev, "No data available to read, waiting\n");
>     +
>     +               spin_unlock_bh(&uchan->dl_pending_lock);
>     +               ret = wait_event_interruptible(uchan->dl_wq,
>     +                                              (!udev->enabled ||
>     +                                           
>       !list_empty(&uchan->dl_pending)));
> 
> 
> If you need to protect dl_pending list against concurent access, you 
> need to do it in wait_event as well. I would suggest to lookg at 
> `wait_event_interruptible_lock_irq` function, that allows to pass a 
> locked spinlock as parameter. That would be safer and prevent this 
> lock/unlock dance.
When using this API difference is, first we take spin_lock_bh() and then 
wait API is using spin_unlock_irq()/spin_lock_irq(). I am getting
"BUG: scheduling while atomic" when i use this way. When i changed 
spin_lock_bh to spin_lock_irq then we got rid of the kernel BUG.

Thanks,
Hemant

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
