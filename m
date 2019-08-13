Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE1B8B037
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfHMGzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:55:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38966 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfHMGzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:55:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id i63so444256wmg.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 23:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wXqaBTkPbHmk2Bz7fHByYh0sML0xdLf/ZuBTB8yOoa8=;
        b=yVp5Ala9/a/7Q9KN416x6K3OCOHY/H2SBYM+liqGr3id/RvlX0gBqjIttsUVFy3dM1
         OGy3AhpScry/qYV4zJxxAbbd4nMpSbIBo+ZhItiCq5TijGBxk91VNGsFOIuR3JNNtcqL
         /W0k0ERbGOZY4tkk/68KXwqgQQsaBmyR+T3t9wXyPhIOO2Kw8gcGMWUFAQTe8ujlg4ZU
         KhOHm49Wp+H3At9+OTcWBYIGoGCOe6SLeUZ3OleYgCpG7/ujr9Lsr6KnuAAUiW4dIu7n
         JJ9bXbwflacu2mz0Y7mc1f77VsA0c0MLDf/oaJlRci/AM15uWR9Z5HmR2PVMorcwZpnV
         eKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wXqaBTkPbHmk2Bz7fHByYh0sML0xdLf/ZuBTB8yOoa8=;
        b=BA11SfTUOUvcXfCtIjqigyei8arnf/1wI5woh3i/Ys5D9KbjMY3GGdZOjiFjxQbfNT
         6vYNKNnPRoRBfqJ9Q9ImlMIZgO7p13JakXUgZ/1AMr+cRBKKh3+T+qubO9ouqIK0KPQM
         w0Mp6rl8msN6iTtsb2F+c9sfNnMUPr5ufsXA2nU2A91mRqkRX48qNNCWOmmcx/FEsFUl
         gbHZ+W61LP9GpywcWFLp8nncJtxHCidYokbaCOq29lKnWD7lyGBwiwdOHC0uKcsZDPws
         orkobIz6M1fJWT0aHIt9zgDG3YbVWnNPEEVWlf+sq8FwS+/5f/SlzTBJRv168ai77vJU
         /6NQ==
X-Gm-Message-State: APjAAAWDRNPwi0aZxRqJMi2WlgZYiytrV6XIAImff8dfCJ0itpcGXj64
        ObWNPO07q/LbOxF1kkQaL9CwQg==
X-Google-Smtp-Source: APXvYqwc53ibS4/eVjzINFEcUP2rX/dZxVqtTuEbk0q0ydUvKkXV3g/ttsK2EHo/RhPlCGR2ttUF3A==
X-Received: by 2002:a1c:f20f:: with SMTP id s15mr1213494wmc.33.1565679312571;
        Mon, 12 Aug 2019 23:55:12 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id d20sm474280wmb.24.2019.08.12.23.55.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 23:55:12 -0700 (PDT)
Date:   Tue, 13 Aug 2019 08:55:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190813065511.GJ2428@nanopsycho>
References: <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
 <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
 <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
 <20190812083139.GA2428@nanopsycho>
 <20190812084039.2fbd1f01@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812084039.2fbd1f01@hermes.lan>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 12, 2019 at 05:40:39PM CEST, stephen@networkplumber.org wrote:
>On Mon, 12 Aug 2019 10:31:39 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> Mon, Aug 12, 2019 at 03:37:26AM CEST, dsahern@gmail.com wrote:
>> >On 8/11/19 7:34 PM, David Ahern wrote:  
>> >> On 8/10/19 12:30 AM, Jiri Pirko wrote:  
>> >>> Could you please write me an example message of add/remove?  
>> >> 
>> >> altnames are for existing netdevs, yes? existing netdevs have an id and
>> >> a name - 2 existing references for identifying the existing netdev for
>> >> which an altname will be added. Even using the altname as the main
>> >> 'handle' for a setlink change, I see no reason why the GETLINK api can
>> >> not take an the IFLA_ALT_IFNAME and return the full details of the
>> >> device if the altname is unique.
>> >> 
>> >> So, what do the new RTM commands give you that you can not do with
>> >> RTM_*LINK?
>> >>   
>> >
>> >
>> >To put this another way, the ALT_NAME is an attribute of an object - a
>> >LINK. It is *not* a separate object which requires its own set of
>> >commands for manipulating.  
>> 
>> Okay, again, could you provide example of a message to add/remove
>> altname using existing setlink message? Thanks!
>
>The existing IFALIAS takes an empty name to do deletion.

Ifalias is one and one only. Woudn't work for multiple altnames...
