Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61BF4F13F9
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 11:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfKFKcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 05:32:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44584 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfKFKcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 05:32:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5278F612C6; Wed,  6 Nov 2019 10:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573036326;
        bh=BFkZ4M/2nzCiB5XacbVjL4KWPYi7IRQjbmDKTBM1gHE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nRuBtDbbpbDDSZaOIq1iTtHGfQxnnyrwyVPrNxmGXEeP3OJcaAMB5wl2XlfSUOWZJ
         yDSm4MtUfhTQ9HvHkYh6JewbGo2NcWAvFMNLHCn9kJajxUpOKdWCAIACo8/ugWOVha
         9k+0tTHbYPd2ngWDBU2POW1Ed7z4jwjXInWEgnQ8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (85-76-103-221-nat.elisa-mobile.fi [85.76.103.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 585DF612D8;
        Wed,  6 Nov 2019 10:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573036325;
        bh=BFkZ4M/2nzCiB5XacbVjL4KWPYi7IRQjbmDKTBM1gHE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bwclr+SD2H59YdMPGZbofsxziLmbzGKeqGG6OUaSA0iNeYIaH15Fu4ePYacK/ZPeb
         D2m2MIoVgRej964eha4+KY/Kn1kLt0Zkj5qTAUmAGqkQGjj4gtDbZGAb2mgledK+D8
         o1WIqk0B4BGxReICRzc7WiXlkyudqJFcl6fCV1wk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 585DF612D8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     Linux-OMAP <linux-omap@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: Long Delay on startup of wl18xx Wireless chip
References: <CAHCN7xJiJKBgkiRm-MF9NpgQqfV4=zSVRShc5Sb5Lya2TAxU0g@mail.gmail.com>
        <CAHCN7xK0Y7=Wr9Kq02CWCbQjWVOocU02LLEB=QsVB22yNNoQPw@mail.gmail.com>
Date:   Wed, 06 Nov 2019 12:32:00 +0200
In-Reply-To: <CAHCN7xK0Y7=Wr9Kq02CWCbQjWVOocU02LLEB=QsVB22yNNoQPw@mail.gmail.com>
        (Adam Ford's message of "Tue, 5 Nov 2019 12:55:51 -0600")
Message-ID: <87sgn1z467.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adam Ford <aford173@gmail.com> writes:

> On Tue, Nov 5, 2019 at 12:25 PM Adam Ford <aford173@gmail.com> wrote:
>>
>> I am seeing a really long delay at startup of the wl18xx using the 5.4 kernel.
>>
>
> Sorry I had to resend.  I forgot to do plaintext.  Google switched
> settings on me and neglected to inform me.
>
>
>> [ 7.895551] wl18xx_driver wl18xx.2.auto: Direct firmware load for
>> ti-connectivity/wl18xx-conf.bin failed with error -2
>> [ 7.906416] wl18xx_driver wl18xx.2.auto: Falling back to sysfs
>> fallback for: ti-connectivity/wl18xx-conf.bin
>>
>> At this point in the sequence, I can login to Linux, but the WL18xx is unavailable.
>>
>> [   35.032382] vwl1837: disabling
>> [ 69.594874] wlcore: ERROR could not get configuration binary
>> ti-connectivity/wl18xx-conf.bin: -11
>> [   69.604013] wlcore: WARNING falling back to default config
>> [   70.174821] wlcore: wl18xx HW: 183x or 180x, PG 2.2 (ROM 0x11)
>> [ 70.189003] wlcore: WARNING Detected unconfigured mac address in
>> nvs, derive from fuse instead.
>> [   70.197851] wlcore: WARNING This default nvs file can be removed from the file system
>> [   70.218816] wlcore: loaded
>>
>> It is now at this point when the wl18xx is available.
>>
>> I have the wl18xx and wlcore setup as a module so it should load
>> after the filesystem is mounted. I am not using a wl18xx-conf.bin,
>> but I never needed to use this before.
>>
>> It seems to me unreasonable to wait 60+ seconds after everything is
>> mounted for the wireless chip to become available. Before I attempt
>> to bisect this, I was hoping someone might have seen this. I am also
>> trying to avoid duplicating someone else's efforts.
>>
>> I know the 4.19 doesn't behave like this.

Try disabling CONFIG_FW_LOADER_USER_HELPER, that usually causes a 60
second delay if the user space is not setup to handle the request. (Or
something like that.)

-- 
Kalle Valo
