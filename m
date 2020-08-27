Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3527254017
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 10:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgH0IDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 04:03:02 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:62090 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbgH0IDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 04:03:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598515380; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=deplzEvxYDzNg5sadmLOiZaUYk7lhFmqIsbII+EbBmw=; b=xGPsfIm7gA+qGrnKx2dBUNlSY9k8fUNlOj24F+Ips0cb+dtBrUuTA0GutgOfr8Yh0Ql+SKlI
 GNR8WmUZ9qCsj9yJ/Jd9Zk/0zd673hPmjyKUX2BP0bHiBPcm/Y9oP245qlD7zn8+j6nLQgz4
 iZJSXwejzjAS0hAI9lAMFqoV8II=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f47689ae2d4d29fc8d95bba (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 08:02:34
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 661A6C43387; Thu, 27 Aug 2020 08:02:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 02436C433C6;
        Thu, 27 Aug 2020 08:02:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 02436C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "\<netdev\@vger.kernel.org\>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kaloyan Nikolov <konik98@gmail.com>
Subject: Re: [PATCH net] mwifiex: Increase AES key storage size to 256 bits
References: <20200825153829.38043-1-luzmaximilian@gmail.com>
        <CA+ASDXPoxdMb4b5d0Ayv=JFACHcq7EXub14pJtJfcCV2di95Rg@mail.gmail.com>
Date:   Thu, 27 Aug 2020 11:02:28 +0300
In-Reply-To: <CA+ASDXPoxdMb4b5d0Ayv=JFACHcq7EXub14pJtJfcCV2di95Rg@mail.gmail.com>
        (Brian Norris's message of "Tue, 25 Aug 2020 12:30:28 -0700")
Message-ID: <87mu2gldnv.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> Hi,
>
> On Tue, Aug 25, 2020 at 8:38 AM Maximilian Luz <luzmaximilian@gmail.com> wrote:
>>
>> Following commit e18696786548 ("mwifiex: Prevent memory corruption
>> handling keys") the mwifiex driver fails to authenticate with certain
>> networks, specifically networks with 256 bit keys, and repeatedly asks
>> for the password. The kernel log repeats the following lines (id and
>> bssid redacted):
>>
>>     mwifiex_pcie 0000:01:00.0: info: trying to associate to '<id>' bssid <bssid>
>>     mwifiex_pcie 0000:01:00.0: info: associated to bssid <bssid> successfully
>>     mwifiex_pcie 0000:01:00.0: crypto keys added
>>     mwifiex_pcie 0000:01:00.0: info: successfully disconnected from <bssid>: reason code 3
>>
>> Tracking down this problem lead to the overflow check introduced by the
>> aforementioned commit into mwifiex_ret_802_11_key_material_v2(). This
>> check fails on networks with 256 bit keys due to the current storage
>> size for AES keys in struct mwifiex_aes_param being only 128 bit.
>>
>> To fix this issue, increase the storage size for AES keys to 256 bit.
>>
>> Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
>> Reported-by: Kaloyan Nikolov <konik98@gmail.com>
>> Tested-by: Kaloyan Nikolov <konik98@gmail.com>
>
> Thanks for this! I just happened to notice this breakage here, as we
> just merged the relevant -stable updates. I think it would be wise to
> get the Fixes tag Dan noted, when Kalle lands this.

Ok, I'll queue this for v5.9 and add the Fixes tag.

If anyone is bored it would be great to get patchwork automatically
pickup the Fixes tags :) It already does that Acked-by, Reported-by and
Tested-by tags:

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Reported-by: Kaloyan Nikolov <konik98@gmail.com>
Tested-by: Kaloyan Nikolov <konik98@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
