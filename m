Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5AD6475A6
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiLHSdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiLHSdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:33:09 -0500
Received: from server.eikelenboom.it (server.eikelenboom.it [91.121.65.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252707A199;
        Thu,  8 Dec 2022 10:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=eikelenboom.it; s=20180706; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xh7NYgKqJIs6p/O05J4xYYF4pKK9kYdP7khjJXgOgSk=; b=F7fd1PyDPZxieCswJjDDZ9UCbv
        nF3RnxOIAWJRm0w4ju2cI30eMoaciQQ9bUN5Tu3wW1SP3oSEqMKWGyD673jHM2Nxa3zHg3+x7vy+t
        46VY3PQjvgDB4euRFgOSr13UQ5ByKjXwwIsHGM1eliLUwALKifBOtlA4mPnGMCSfm04Y=;
Received: from 131-195-250-62.ftth.glasoperator.nl ([62.250.195.131]:58874 helo=[172.16.1.50])
        by server.eikelenboom.it with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <linux@eikelenboom.it>)
        id 1p3LhV-0002BF-8r; Thu, 08 Dec 2022 19:32:53 +0100
Message-ID: <c5dc1c91-dd32-e233-6029-10b175fc1eff@eikelenboom.it>
Date:   Thu, 8 Dec 2022 19:31:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: Xen + linux 6.1.0-rc8, network to guest VM not working after
 commit ad7f402ae4f466647c3a669b8a6f3e5d4271c84a fixing XSA-423
To:     Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Ross Lagerwall <ross.lagerwall@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Xen-devel <xen-devel@lists.xen.org>, Paul Durrant <paul@xen.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <2f364567-3598-2d86-ae3d-e0fabad4704a@eikelenboom.it>
 <56054539-4a02-5310-b93f-6baacaf8e007@citrix.com>
Content-Language: nl-NL, en-US
From:   Sander Eikelenboom <linux@eikelenboom.it>
In-Reply-To: <56054539-4a02-5310-b93f-6baacaf8e007@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2022 00:00, Andrew Cooper wrote:
> On 07/12/2022 21:42, Sander Eikelenboom wrote:
>> Hi Ross / Juergen,
>>
>> I just updated my linux kernel to the latest of Linus his tree which
>> included commit ad7f402ae4f466647c3a669b8a6f3e5d4271c84a fixing XSA-423.
>>
>> Unfortunately when using this kernel I can't SSH anymore into the Xen
>> guest I start, but I don't see any apparent failures either.
>> A straight revert of the commit
>> ad7f402ae4f466647c3a669b8a6f3e5d4271c84a makes networking function
>> normally again.
>>
>> I have added some of the logging below, perhaps it at gives some idea
>> off the state around the Xen network front and backend.
>>
>> Any ideas or a test patch that I could run to shed some more light on
>> what is going on ?
> 
> XSA-423 was buggy.  Fix and discussion at:
> 
> https://lore.kernel.org/xen-devel/681773dd-6264-63ac-a3b5-a9182b9e0cc1@suse.com/T/#t
> 
> ~Andrew

Thanks for the pointer Andrew, that fix works for me as well!
What a difference a few characters can make :)

--
Sander
