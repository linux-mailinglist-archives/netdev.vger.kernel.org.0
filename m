Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B992BBCC2
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgKUDol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 22:44:41 -0500
Received: from z5.mailgun.us ([104.130.96.5]:12976 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgKUDol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 22:44:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605930280; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=WUF9vNijxF2NrVfabfsan6qxRJo2BPnBDbY00KnZ4jg=; b=MUdTZ2aaQ8fbJsrkAlOHxCF048UfyvFDq0ImXuREiM9nOOjjmwS/AabYP6ZHxiSdhWtg7Eyo
 J5uNuBpspmbB6Z+PnTAsvXVWDKj07CSluhL7J8kQ7XEFlvIsP/E/nQRWmynZUqMjuazNeEJf
 6FyeyCgbXXlQ6DrHGf+HLfbYmdU=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5fb88d211b731a5d9c3511e4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Nov 2020 03:44:33
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7F44FC43464; Sat, 21 Nov 2020 03:44:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CCE27C433ED;
        Sat, 21 Nov 2020 03:44:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CCE27C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v12 5/5] selftest: mhi: Add support to test MHI LOOPBACK
 channel
To:     Shuah Khan <skhan@linuxfoundation.org>,
        manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
References: <1605566782-38013-1-git-send-email-hemantk@codeaurora.org>
 <1605566782-38013-6-git-send-email-hemantk@codeaurora.org>
 <f337319e-d542-67b3-f31e-e4366d822d76@linuxfoundation.org>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <cfcbb987-89b9-dff2-bd88-abffb9c8cbc6@codeaurora.org>
Date:   Fri, 20 Nov 2020 19:44:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f337319e-d542-67b3-f31e-e4366d822d76@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shuah,

On 11/20/20 7:26 AM, Shuah Khan wrote:
> On 11/16/20 3:46 PM, Hemant Kumar wrote:
>> Loopback test opens the MHI device file node and writes
>> a data buffer to it. MHI UCI kernel space driver copies
>> the data and sends it to MHI uplink (Tx) LOOPBACK channel.
>> MHI device loops back the same data to MHI downlink (Rx)
>> LOOPBACK channel. This data is read by test application
>> and compared against the data sent. Test passes if data
>> buffer matches between Tx and Rx. Test application performs
>> open(), poll(), write(), read() and close() file operations.
>>
>> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
>> ---
>>   Documentation/mhi/uci.rst                          |  32 +
>>   tools/testing/selftests/Makefile                   |   1 +
>>   tools/testing/selftests/drivers/.gitignore         |   1 +
>>   tools/testing/selftests/drivers/mhi/Makefile       |   8 +
>>   tools/testing/selftests/drivers/mhi/config         |   2 +
>>   .../testing/selftests/drivers/mhi/loopback_test.c  | 802 
>> +++++++++++++++++++++
>>   6 files changed, 846 insertions(+)
>>   create mode 100644 tools/testing/selftests/drivers/mhi/Makefile
>>   create mode 100644 tools/testing/selftests/drivers/mhi/config
>>   create mode 100644 tools/testing/selftests/drivers/mhi/loopback_test.c
>>
>> diff --git a/Documentation/mhi/uci.rst b/Documentation/mhi/uci.rst
>> index ce8740e..0a04afe 100644
>> --- a/Documentation/mhi/uci.rst
>> +++ b/Documentation/mhi/uci.rst
>> @@ -79,6 +79,38 @@ MHI client driver performs read operation, same 
>> data gets looped back to MHI
>>   host using LOOPBACK channel 1. LOOPBACK channel is used to verify 
>> data path
>>   and data integrity between MHI Host and MHI device.
> 
> Nice.
[..]
>> +
>> +enum debug_level {
>> +    DBG_LVL_VERBOSE,
>> +    DBG_LVL_INFO,
>> +    DBG_LVL_ERROR,
>> +};
>> +
>> +enum test_status {
>> +    TEST_STATUS_SUCCESS,
>> +    TEST_STATUS_ERROR,
>> +    TEST_STATUS_NO_DEV,
>> +};
>> +
> 
> Since you are running this test as part of kselftest, please use
> ksft errors nd returns.
Are you suggesting to use following macros instead of test_status enum ?
#define KSFT_PASS  0
#define KSFT_FAIL  1

> 
>> +struct lb_test_ctx {
>> +    char dev_node[256];
>> +    unsigned char *tx_buff;
>> +    unsigned char *rx_buff;
>> +    unsigned int rx_pkt_count;
>> +    unsigned int tx_pkt_count;
>> +    int iterations;
>> +    bool iter_complete;
>> +    bool comp_complete;
>> +    bool test_complete;
>> +    bool all_complete;
>> +    unsigned long buff_size;
>> +    long byte_recvd;
>> +    long byte_sent;
>> +};
>> +
>> +bool force_exit;
>> +char write_data = 'a';
>> +int completed_iterations;
>> +
>> +struct lb_test_ctx test_ctxt;
>> +enum debug_level msg_lvl;
>> +struct pollfd read_fd;
>> +struct pollfd write_fd;
>> +enum test_status mhi_test_return_value;
>> +enum test_status tx_status;
>> +enum test_status rx_status;
>> +enum test_status cmp_rxtx_status;
>> +
>> +#define test_log(test_msg_lvl, format, ...) do { \
>> +        if (test_msg_lvl >= msg_lvl) \
>> +            fprintf(stderr, format, ##__VA_ARGS__); \
>> +} while (0)
>> +
>> +static void loopback_test_sleep_ms(int ms)
>> +{
>> +    usleep(1000 * ms);
>> +}
>> +
> 
> Have you run this as part of "make kselftest" run. How does this
> sleep work in that env.?
Looks like kselftest runs this test application by directly executing 
the binary, but this test application requires a valid mhi device file 
node as a required parameter. So considering that requirement, is this 
test application qualifies to run using kselftest ? Without a valid 
device file node test would fail. Is there an option to run this test as 
standalone test which can only be run when a mhi device file node is 
present ? Having said that i tested this driver by
directly executing it using the test binary which is compiled using
make loopback_test under mhi dir.

> Are there any cases where this test can't run and have to - those
> cases need to be skips.
Yes, as this test application can not run by itself it needs a valid mhi 
device file node to write and test reads the same device node to get the 
data back.
So test can not be run without having a MHI device connected over a 
transport (in my testing MHI device is connected over PCIe). Could you 
please suggest an option to use this test application as a standalone 
test instead of being part of kselftest?
> 
> thanks,
> -- Shuah

Thanks,
Hemant
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
