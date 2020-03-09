Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6131B17E224
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 15:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgCIOEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 10:04:39 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:49234 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgCIOEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 10:04:39 -0400
Received: from [192.168.254.4] (unknown [50.34.210.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id EE61313C344;
        Mon,  9 Mar 2020 07:04:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com EE61313C344
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1583762678;
        bh=Le98ODmUxh2hQ4bGpJJt0SPEeLoeZXUn0R03xpgLpuk=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=hr5F0z0829W8DAc93zBp77V+9ArdSm/Uw4EO6VKbwZObRzMz+xUQJdTK+rFQFXyUs
         U4zr4nix5vG/RVZkQfd6dOuW6pYQfb745qLCPly6aFqhVABDaUtCGDAUeIAEa2HYCR
         6N5UGO4EhqGzgyxsSYXDfQ5AEbSWrH8EymIUYXew=
Subject: Re: [PATCH] ip link: Prevent duplication of table id for vrf tables
To:     David Ahern <dsahern@gmail.com>,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        netdev@vger.kernel.org, dsahern@kernel.org,
        roopa@cumulusnetworks.com, sworley@cumulusnetworks.com
References: <20200307205916.15646-1-sharpd@cumulusnetworks.com>
 <b36df09f-2e15-063e-4b58-1b864bed8751@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <c8145b59-6f26-ab55-c33a-362fe87fd59b@candelatech.com>
Date:   Mon, 9 Mar 2020 07:04:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <b36df09f-2e15-063e-4b58-1b864bed8751@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/08/2020 07:22 PM, David Ahern wrote:
> On 3/7/20 1:59 PM, Donald Sharp wrote:
>> Creation of different vrf's with duplicate table id's creates
>> a situation where two different routing entities believe
>> they have exclusive access to a particular table.  This
>> leads to situations where different routing processes
>> clash for control of a route due to inadvertent table
>> id overlap.  Prevent end user from making this mistake
>> on accident.
>
> I get the pain, but it is a user management problem and ip is but one
> tool. I think at most ip warns the user about the table duplication; it
> can't fail the create.

You could default 'ip' to use the safe mode, and allow a --force option if
there is some reason why it should be allowed?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
