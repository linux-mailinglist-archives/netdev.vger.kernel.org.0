Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A261E6379A
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 16:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfGIOSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 10:18:22 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52196 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfGIOSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 10:18:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so3297556wma.1
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 07:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zAfWkGTqy/4+jQo0giTgwlHBdMjJZDPW1KI+35w/1So=;
        b=MzzNa06lRdFpz/NDLEEeMkVDhuvw2olLDScYMkyTard5PpwGHeT6eL89YrG21nCAhS
         XOmu2RC5g7DaLUXJeNiapGREo/9mgzuZCFm6G+ChhtZnYp0jb7QzQJBjCSqpBzgpQ6wZ
         gV0PE1ypvTuvtPLtsHrL1J24WS2GyuOOW6+KDRQDbGokgPumDETst39ata1/q9giFr3G
         /RWOcWT43+tC7eyZUr4BfB6dDhdW9ETaVC6FEBiUiJr/SJI1qMidbF2PRZp6lzI7wkv2
         pR4XXPbIO+9HZ0nvfVAbTQqHkLmzwIi9yRIt2uxBaPNcwXOccr4+Wzegp0m/SD06i7IS
         RhWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zAfWkGTqy/4+jQo0giTgwlHBdMjJZDPW1KI+35w/1So=;
        b=GJaiIvhtMvmH+iHPjKFQTRJuyD/j1jHAO8+DbXhASft8ZgovX9E6jZH94R5Znwhf1A
         A9ztDnKf+lKNBUKsn/TbatrZzgXaUuiUTblBTGLeswEsk5oa4UT3ElFvfxASewYOg6Xa
         M5Qai3GvKKjKx/JncdFpP7JSR/z036DJ6cbPQLCPp+T4qRBBFhjuNlidaf8MsiG6X0rD
         5QqxmarAdFB7u46czZvFAaztUHFoy4l9XrWGxCoo4cG6Aezi6ynG/EF2c2POcMRiLm5I
         TzVkBGFhxSIxIG4GWq0C/M0VQ5R13EZd2t3s81q1sHa1tLlwuMexBTc+cEYjhz3BYNOs
         kJPg==
X-Gm-Message-State: APjAAAVbbZLK5B0qxt0VgBc9fg6nWu9hJ3armzkS2oRqxp5mLMP8x+ls
        ooZoNF+tHTjo2544x6t7b0s=
X-Google-Smtp-Source: APXvYqzCTRpFQwyIoXWEUjn/NVKXHfiD/OvyMQBa6YuYeqigTV6oOTZ9pJa+Addu63ORS1iQItwRng==
X-Received: by 2002:a1c:f918:: with SMTP id x24mr223582wmh.132.1562681898990;
        Tue, 09 Jul 2019 07:18:18 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x11sm2433780wmi.26.2019.07.09.07.18.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 07:18:18 -0700 (PDT)
Date:   Tue, 9 Jul 2019 16:18:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
Message-ID: <20190709141817.GE2301@nanopsycho.orion>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
 <20190703114933.GW2250@nanopsycho>
 <20190703181851.GP20101@unicorn.suse.cz>
 <20190704080435.GF2250@nanopsycho>
 <20190704115236.GR20101@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704115236.GR20101@unicorn.suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 04, 2019 at 01:52:36PM CEST, mkubecek@suse.cz wrote:
>On Thu, Jul 04, 2019 at 10:04:35AM +0200, Jiri Pirko wrote:
>> Wed, Jul 03, 2019 at 08:18:51PM CEST, mkubecek@suse.cz wrote:
>> >On Wed, Jul 03, 2019 at 01:49:33PM +0200, Jiri Pirko wrote:
>> >> Tue, Jul 02, 2019 at 01:50:09PM CEST, mkubecek@suse.cz wrote:
>> >> >+Compact form: nested (bitset) atrribute contents:
>> >> >+
>> >> >+    ETHTOOL_A_BITSET_LIST	(flag)		no mask, only a list
>> >> >+    ETHTOOL_A_BITSET_SIZE	(u32)		number of significant bits
>> >> >+    ETHTOOL_A_BITSET_VALUE	(binary)	bitmap of bit values
>> >> >+    ETHTOOL_A_BITSET_MASK	(binary)	bitmap of valid bits
>> >> >+
>> >> >+Value and mask must have length at least ETHTOOL_A_BITSET_SIZE bits rounded up
>> >> >+to a multiple of 32 bits. They consist of 32-bit words in host byte order,
>> >> 
>> >> Looks like the blocks are similar to NLA_BITFIELD32. Why don't you user
>> >> nested array of NLA_BITFIELD32 instead?
>> >
>> >That would mean a layout like
>> >
>> >  4 bytes of attr header
>> >  4 bytes of value
>> >  4 bytes of mask
>> >  4 bytes of attr header
>> >  4 bytes of value
>> >  4 bytes of mask
>> >  ...
>> >
>> >i.e. interleaved headers, words of value and words of mask. Having value
>> >and mask contiguous looks cleaner to me. Also, I can quickly check the
>> >sizes without iterating through a (potentially long) array.
>> 
>> Yeah, if you are not happy with this, I suggest to introduce
>> NLA_BITFIELD with arbitrary size. That would be probably cleanest.
>
>There is still the question if it it should be implemented as a nested
>attribute which could look like the current compact form without the
>"list" flag (if there is no mask, it's a list). Or an unstructured data
>block consisting of u32 bit length and one or two bitmaps of
>corresponding length. I would prefer the nested attribute, netlink was
>designed to represent structured data, passing structures as binary goes
>against the design (just looked at VFINFO in rtnetlink few days ago,
>it's awful, IMHO).
>
>Either way, I would still prefer to have bitmaps represented as an array
>of 32-bit blocks in host byte order. This would be easy to handle in
>kernel both in places where we have u32 based bitmaps and unsigned long
>based ones. Other options seem less appealing:
>
>  - u8 based: only complicates processing
>  - u64 based: have to care about alignment
>  - unsigned long based: alignment and also problems with 64-bit kernel
>    vs. 32-bit userspace
>
>> >> This is quite complex and confusing. Having the same API for 2 APIs is
>> >> odd. The API should be crystal clear, easy to use.
>> >> 
>> >> Why can't you have 2 commands, one working with bit arrays only, one
>> >> working with strings? Something like:
>> >> X_GET
>> >>    ETHTOOL_A_BITS (nested)
>> >>       ETHTOOL_A_BIT_ARRAY (BITFIELD32)
>> >> X_NAMES_GET
>> >>    ETHTOOL_A_BIT_NAMES (nested)
>> >> 	ETHTOOL_A_BIT_INDEX
>> >> 	ETHTOOL_A_BIT_NAME
>> >> 
>> >> For set, you can also have multiple cmds:
>> >> X_SET  - to set many at once, by bit index
>> >>    ETHTOOL_A_BITS (nested)
>> >>       ETHTOOL_A_BIT_ARRAY (BITFIELD32)
>> >> X_ONE_SET   - to set one, by bit index
>> >>    ETHTOOL_A_BIT_INDEX
>> >>    ETHTOOL_A_BIT_VALUE
>> >> X_ONE_SET   - to set one, by name
>> >>    ETHTOOL_A_BIT_NAME
>> >>    ETHTOOL_A_BIT_VALUE
>> >
>> >This looks as if you assume there is nothing except the bitset in the
>> >message but that is not true. Even with your proposed breaking of
>> >current groups, you would still have e.g. 4 bitsets in reply to netdev
>> >features query, 3 in timestamping info GET request and often bitsets
>> >combined with other data (e.g. WoL modes and optional WoL password).
>> >If you wanted to further refine the message granularity to the level of
>> >single parameters, we might be out of message type ids already.
>> 
>> You can still have multiple bitsets(bitfields) in single message and
>> have separate cmd/cmds to get string-bit mapping. No need to mangle it.
>
>Let's take a look at what it means in practice, the command is
>
>  ethtool --set-prif-flags eth3 legacy-rx on
>
>on an ixgbe card. Currently, ethtool (from the github repository) does
>
>------------------------------------------------------------------------
>ETHTOOL_CMD_SETTINGS_SET (K->U, 68 bytes)
>    ETHTOOL_A_HEADER
>        ETHTOOL_A_DEV_NAME = "eth3"
>    ETHTOOL_A_SETTINGS_PRIV_FLAGS
>        ETHTOOL_A_BITSET_BITS
>            ETHTOOL_A_BITS_BIT
>                ETHTOOL_A_BIT_NAME = "legacy-rx"
>                ETHTOOL_A_BIT_VALUE
>
>NLMSG_ERR (K->U, 36 bytes) err = 0
>------------------------------------------------------------------------
>
>If we had only compact form (or some of the NLA_BITFIELD solutions we
>are talking about), you would need
>
>------------------------------------------------------------------------
>ETHTOOL_CMD_STRSET_GET (U->K, 52 bytes)
>    ETHTOOL_A_HEADER
>        ETHTOOL_A_DEV_NAME = "eth3"
>    ETHTOOL_A_STRSET_STRINGSETS
>        ETHTOOL_A_STRINGSETS_STRINGSET
>            ETHTOOL_A_STRINGSET_ID = 2 (ETH_SS_PRIV_FLAGS)
>
>ETHTOOL_CMD_STRSET_GET_REPLY (K->U, 128 bytes)
>    ETHTOOL_A_HEADER
>        ETHTOOL_A_DEV_INDEX = 9
>        ETHTOOL_A_DEV_NAME = "eth3"
>    ETHTOOL_A_STRSET_STRINGSETS
>        ETHTOOL_A_STRINGSETS_STRINGSET
>            ETHTOOL_A_STRINGSET_ID = 2 (ETH_SS_PRIV_FLAGS)
>            ETHTOOL_A_STRINGSET_COUNT = 2
>            ETHTOOL_A_STRINGSET_STRINGS
>                ETHTOOL_A_STRINGS_STRING
>                    ETHTOOL_A_STRING_INDEX = 0
>                    ETHTOOL_A_STRING_VALUE = "legacy-rx"
>                ETHTOOL_A_STRINGS_STRING
>                    ETHTOOL_A_STRING_INDEX = 1
>                    ETHTOOL_A_STRING_VALUE = "vf-ipsec"
>
>NLMSG_ERR (K->U, 36 bytes) err = 0
>
>ETHTOOL_CMD_SETTINGS_SET (K->U, 64 bytes)
>    ETHTOOL_A_HEADER
>        ETHTOOL_A_DEV_NAME = "eth3"
>    ETHTOOL_A_SETTINGS_PRIV_FLAGS
>        ETHTOOL_A_BITSET_SIZE = 2
>        ETHTOOL_A_BITSET_VALUE = 00000001
>        ETHTOOL_A_BITSET_MASK = 00000001
>
>NLMSG_ERR (K->U, 36 bytes) err = 0
>------------------------------------------------------------------------
>
>That's an extra roundtrip, lot more chat and the SETTINGS_SET message is
>only 4 bytes shorter in the end. And we can consider ourselves lucky
>this NIC has only two private flags. Or that we didn't need to enable or
>disable a netdev feature (56 bits) or link mode (69 bits and growing).
>
>We could reduce the overhead by allowing STRSET_GET query to only ask
>for specific string(s) but there would still be the extra roundtrip
>which I dislike in the ioctl interface. Florian also said in the v5
>discussion that he would like if it was possible to get names and data
>together in one request.

I understand. So how about avoid the bitfield all together and just
have array of either bits of strings or combinations?

ETHTOOL_CMD_SETTINGS_SET (U->K)
    ETHTOOL_A_HEADER
        ETHTOOL_A_DEV_NAME = "eth3"
    ETHTOOL_A_SETTINGS_PRIV_FLAGS
       ETHTOOL_A_SETTINGS_PRIV_FLAG
           ETHTOOL_A_FLAG_NAME = "legacy-rx"
	   ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)

or the same with index instead of string

ETHTOOL_CMD_SETTINGS_SET (U->K)
    ETHTOOL_A_HEADER
        ETHTOOL_A_DEV_NAME = "eth3"
    ETHTOOL_A_SETTINGS_PRIV_FLAGS
        ETHTOOL_A_SETTINGS_PRIV_FLAG
            ETHTOOL_A_FLAG_INDEX = 0
 	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)


For set you can combine both when you want to set multiple bits:

ETHTOOL_CMD_SETTINGS_SET (U->K)
    ETHTOOL_A_HEADER
        ETHTOOL_A_DEV_NAME = "eth3"
    ETHTOOL_A_SETTINGS_PRIV_FLAGS
        ETHTOOL_A_SETTINGS_PRIV_FLAG
            ETHTOOL_A_FLAG_INDEX = 2
 	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
        ETHTOOL_A_SETTINGS_PRIV_FLAG
            ETHTOOL_A_FLAG_INDEX = 8
 	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
        ETHTOOL_A_SETTINGS_PRIV_FLAG
            ETHTOOL_A_FLAG_NAME = "legacy-rx"
 	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)


For get this might be a bit bigger message:

ETHTOOL_CMD_SETTINGS_GET_REPLY (K->U)
    ETHTOOL_A_HEADER
        ETHTOOL_A_DEV_NAME = "eth3"
    ETHTOOL_A_SETTINGS_PRIV_FLAGS
        ETHTOOL_A_SETTINGS_PRIV_FLAG
            ETHTOOL_A_FLAG_INDEX = 0
            ETHTOOL_A_FLAG_NAME = "legacy-rx"
 	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
        ETHTOOL_A_SETTINGS_PRIV_FLAG
            ETHTOOL_A_FLAG_INDEX = 1
            ETHTOOL_A_FLAG_NAME = "vf-ipsec"
 	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)
        ETHTOOL_A_SETTINGS_PRIV_FLAG
            ETHTOOL_A_FLAG_INDEX = 8
            ETHTOOL_A_FLAG_NAME = "something-else"
 	    ETHTOOL_A_FLAG_VALUE   (NLA_FLAG)


>
>Michal
