Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEA053B7EA
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 13:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiFBLhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 07:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiFBLhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 07:37:04 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5757B3DDDD;
        Thu,  2 Jun 2022 04:37:01 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id i10so7416434lfj.0;
        Thu, 02 Jun 2022 04:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=QhgQbZWu2ePNiL3kMffzc1g5XrP31lL0xDbJldxuiGY=;
        b=M4t2nL/LCOWMr0V/YY9BBpnfhddK4t6Gl1lkZJ+TkHO6s8enHiaddn/RhaCwpPgXiO
         gdiwCkA8W4vD2BkM8rqL3V0/W91hvX337zO9s8lmkdd4tUz49tR+VscPfDTYzjYDUzD0
         4aFmSb09d0uc8VwlyarQXo5N5UGpwSZLGPrMFrsHxVu97bNsTOyQhn55ZQjSpj4ZpBsO
         jYwqu9Dv0EskGdBCnAoMb3Kcukj6xFOCpcC4NskgBOsvGsADKkq6Q7JORcV8Y5C/V9mO
         jtpMCsFqlY7p8EtQ4fjBG4TU7GITmsmPe8m61t+CyMBcf4gURvxtPWMcWchk0nl3BzRF
         oRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QhgQbZWu2ePNiL3kMffzc1g5XrP31lL0xDbJldxuiGY=;
        b=jsrCaZIFB44XbcLjb0/X4AxGNT0LOBW90G37o6ghQExBP5OuIiXmroT0ZJUTDIWWKs
         sQyo4ewVuMeLWHrGZncr7fqsO5Lc2W7+yY58p8mC4mZq1mijF0BjbgDg9A1h3DHMlWBD
         vZC7Al8LTAxXx/BC1LIo53F8psoDoTXAWzTZ+lLaAzLUEmJZ2fBjt+YKrQ0nOYL0OlmC
         10AABxmWLTSOEP3gtMUiKv7ioWmSsMmm7H1CI8Ot2aFgp81APJxGeCPueCWOxDIodDZy
         AdFdQENO17vbuvRCoJM0oP0jsHdKXKemoqdjLr94V96u+ZAz+fTmZEE6DmRc7BmSB7yh
         NpLQ==
X-Gm-Message-State: AOAM533CLmSa57CdkNnKBwBNwZoISZ99heYyesIWzCK5N0ksBGSqvzBe
        2/wZHYryg2mEJBTLMAexkLIhTPprtFv/jQ==
X-Google-Smtp-Source: ABdhPJx2ZwZMc6l3wFvubNZybiksfRe/jz2RVM5jGLd1JkTPBjOzUEYnV5PXcTd9GviWD3ZKktIgAQ==
X-Received: by 2002:a05:6512:3c93:b0:44b:4ba:c334 with SMTP id h19-20020a0565123c9300b0044b04bac334mr3300232lfv.27.1654169819579;
        Thu, 02 Jun 2022 04:36:59 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.28])
        by smtp.gmail.com with ESMTPSA id h12-20020ac25d6c000000b004740f2bb4d5sm978972lft.258.2022.06.02.04.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 04:36:59 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Hans Schultz <schultz.hans@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
In-Reply-To: <YpiTbOsh0HBMwiTE@shredder>
References: <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <Yo+LAj1vnjq0p36q@shredder> <86sfov2w8k.fsf@gmail.com>
 <YpCgxtJf9Qe7fTFd@shredder> <86sfoqgi5e.fsf@gmail.com>
 <YpYk4EIeH6sdRl+1@shredder> <86y1yfzap3.fsf@gmail.com>
 <d88b6090-2ac8-0664-0e38-bb2860be7f6e@blackwall.org>
 <86sfonjroi.fsf@gmail.com>
 <3d93d46d-c484-da0a-c12c-80e83eba31c9@blackwall.org>
 <YpiTbOsh0HBMwiTE@shredder>
Date:   Thu, 02 Jun 2022 13:36:56 +0200
Message-ID: <86pmjrjnzb.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tor, jun 02, 2022 at 13:39, Ido Schimmel <idosch@nvidia.com> wrote:
> On Thu, Jun 02, 2022 at 01:30:06PM +0300, Nikolay Aleksandrov wrote:
>> On 02/06/2022 13:17, Hans Schultz wrote:
>> > On tor, jun 02, 2022 at 12:33, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> >> On 02/06/2022 12:17, Hans Schultz wrote:
>> >>> On tis, maj 31, 2022 at 17:23, Ido Schimmel <idosch@nvidia.com> wrote:
>> >>>> On Tue, May 31, 2022 at 11:34:21AM +0200, Hans Schultz wrote:
>> > 
>> >>> Another issue is that
>> >>> bridge fdb add MAC dev DEV master static
>> >>> seems to add the entry with the SELF flag set, which I don't think is
>> >>> what we would want it to do or?
>> >>
>> >> I don't see such thing (hacked iproute2 to print the flags before cmd):
>> >> $ bridge fdb add 00:11:22:33:44:55 dev vnet110 master static
>> >> flags 0x4
>> >>
>> >> 0x4 = NTF_MASTER only
>> >>
>> > 
>> > I also get 0x4 from iproute2, but I still get SELF entries when I look
>> > with:
>> > bridge fdb show dev DEV
>> > 
>> 
>> after the above add:
>> $ bridge fdb show dev vnet110 | grep 00:11
>> 00:11:22:33:44:55 master virbr0 static

>
> I think Hans is testing with mv88e6xxx which dumps entries directly from
> HW via ndo_fdb_dump(). See dsa_slave_port_fdb_do_dump() which sets
> NTF_SELF.
>
> Hans, are you seeing the entry twice? Once with 'master' and once with
> 'self'?
>

Well yes, but I get some additional entries with 'self' for different
vlans. So from clean adding a random fdb entry I get 4 entries on the
port, 2 with 'master' and two with 'self'.
It looks like this:

# bridge fdb add  00:22:33:44:55:66 dev eth6 master static
# bridge fdb show dev eth6 | grep 55
00:22:33:44:55:66 vlan 1 master br0 offload static
00:22:33:44:55:66 master br0 offload static
00:22:33:44:55:66 vlan 1 self static
00:22:33:44:55:66 vlan 4095 self static

If I do a replace of a locked entry I only get one with the 'self' flag.
