Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A486127E36F
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 10:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgI3IQn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 30 Sep 2020 04:16:43 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:44910 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgI3IQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 04:16:43 -0400
Received: from marcel-macpro.fritz.box (p4fefc7f4.dip0.t-ipconnect.de [79.239.199.244])
        by mail.holtmann.org (Postfix) with ESMTPSA id 18024CECB0;
        Wed, 30 Sep 2020 10:23:41 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: Removal of HCI commands, userspace bluetooth regression?
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200930080205.GA1571308@kroah.com>
Date:   Wed, 30 Sep 2020 10:16:40 +0200
Cc:     =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        David Heidelberg <david@ixit.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B9D64012-BF9A-4C2A-8D3D-D789533DFAD0@holtmann.org>
References: <20191228171212.56anj4d4kvjeqhms@pali>
 <45BB2908-4E16-4C74-9DB4-8BAD93B42A21@holtmann.org>
 <20200104102436.bhqagqrfwupj6hkm@pali> <20200209132137.7pi4pgnassosh3ax@pali>
 <20200414225618.zgh5h4jexahfukdl@pali> <20200808132747.4byefjg5ysddgkel@pali>
 <20200929213254.difivzrhapk766xp@pali> <20200930080205.GA1571308@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

>>>>>>>> I wrote a simple script "sco_features.pl" which show all supported
>>>>>>>> codecs by local HCI bluetooth adapter. Script is available at:
>>>>>>>> 
>>>>>>>> https://github.com/pali/hsphfpd-prototype/blob/prototype/sco_features.pl
>>>>>>>> 
>>>>>>>> And I found out that OCF_READ_LOCAL_CODECS HCI command cannot be send by
>>>>>>>> non-root user. Kernel returns "Operation not permitted" error.
>>>>>>>> 
>>>>>>>> What is reason that kernel blocks OCF_READ_LOCAL_CODECS command for
>>>>>>>> non-root users? Without it (audio) application does not know which
>>>>>>>> codecs local bluetooth adapter supports.
>>>>>>>> 
>>>>>>>> E.g. OCF_READ_LOCAL_EXT_FEATURES or OCF_READ_VOICE_SETTING commands can
>>>>>>>> be send also by non-root user and kernel does not block them.
>>>>>>> 
>>>>>>> actually the direct access to HCI commands is being removed. So we have no plans to add new commands into the list since that it what the kernel is suppose to handle. If we wanted to expose this, then it has to be via mgmt.
>>>>>> 
>>>>>> Hi Marcel! Thank you for information. I have not know that this API is
>>>>>> "deprecated" and is going to be removed. But userspace audio
>>>>>> applications need to know what bluetooth adapter supports, so can you
>>>>>> export result of these commands to userspace? My script linked above
>>>>>> calls: OCF_READ_VOICE_SETTING, OCF_READ_LOCAL_COMMANDS,
>>>>>> OCF_READ_LOCAL_EXT_FEATURES, OCF_READ_LOCAL_CODECS
>>>>> 
>>>>> Hello! Just a gently reminder for this question. How to retrieve
>>>>> information about supported codecs from userspace by non-root user?
>>>>> Because running all bluetooth audio applications by root is not really a
>>>>> solution. Plus if above API for root user is going to be removed, what
>>>>> is a replacement?
>>>> 
>>>> Hello!
>>>> 
>>>> I have not got any answer to my email from Marcel for months, so I'm
>>>> adding other developers to loop. Could somebody tell me that is the
>>>> replacement API if above one is going to be removed?
>>>> 
>>>> I was not able to find any documentation where could be described this
>>>> API nor information about deprecation / removal.
>>>> 
>>>> And are you aware of the fact that removing of API could potentially
>>>> break existing applications?
>>>> 
>>>> I really need to know which API should I use, because when I use API
>>>> which is going to be removed, then my application stops working. And I
>>>> really want to avoid it.
>>>> 
>>>> Also I have not got any response yet, how can I read list of supported
>>>> codecs by bluetooth adapter by ordinary non-root user? Audio application
>>>> needs to know list of supported codecs and it is really insane to run it
>>>> as root.
>>> 
>>> Hello! This is just another reminder that I have not got any reply to
>>> this email.
>>> 
>>> Does silence mean that audio applications are expected to work only
>>> under root account and ordinary users are not able to use audio and list
>>> supported codecs?
>> 
>> Hello! I have not got any reply for this issue for 10 months and if you
>> are going to remove (or after these 10 months you already did it?)
>> existing HCI API from kernel it would break existing and working
>> userspace application. How do you want to handle such regressions?
> 
> What git commit caused this regression?

there is no regression!

New Bluetooth standards added new HCI commands that are just not exposed to unprivileged users.

Regards

Marcel

