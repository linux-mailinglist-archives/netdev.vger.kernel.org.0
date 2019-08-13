Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1DC8B024
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfHMGvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:51:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51599 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMGvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:51:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so437580wma.1
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 23:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Sb+nqAbv6l3B7SSlSdTqHeOswJDlv5Uimvb8N21jcTU=;
        b=zSvjzMnKJuq5IGhcrBxUOI37Apq6J0igO0iouimJT61Jx2Vpjqpn2cOa3ijaDihvwo
         nb8LjcXA7MGe7SY6B2zEzSzt8+r8r9sYdcxkXEz0T+hdjKcMIr4FqyUJBrOZgelcS3kb
         M8/ZxTQg7U1hh+ibsNbipdwipfs79Gv2bQeDuaBrdTwDV6AciXsFa7VClq6/yt+YVEdf
         WZ2oAgBxM+wm8A7k07Q0D6UMBPeFVc113dUKgAG796W2NF6wTIQSuBIcq9Y2ut6fHp/x
         3f7IPwENseUwtpRj/lKILhYNflWQV3vfvpEgjOlMKmbsLywEoEs/igbXfqotXvWWg7hw
         KC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Sb+nqAbv6l3B7SSlSdTqHeOswJDlv5Uimvb8N21jcTU=;
        b=QX4WzuU9Heh7u4uUOtX+gFy5kk8kdfdoQXLCeaWwSfv2JeFeE3ZtJHBCacPiAepHnQ
         ZrMuWp8k+KDSH4Ab8FIKh46Gpuh3dFsp8jlf02D08zQS7ECqQQWj6vnUkNYJz8T9fE5w
         krvJ4YOEsrsakGeX3n2vxoiqNgIgSMnC/eay6VQt+nDHqNv1LtIbcFj84h4Hhxky4ZE4
         2OQW9yilv1s8kDhFhdFyT6rATXlve/WNCc90miQ0TrDqqjFk9zfRexDemeQY7JXnsMmP
         SHnuSJ0TUksAOQQVVbQx5Z1m1rUTw9GwDk3xpjjjiWS1FXQ8G/tXyu+EnoHl8NOPOWVs
         lJ1Q==
X-Gm-Message-State: APjAAAUkXSNhAGosijzIxQNbKfXbXBE81UE5E7TPACYBQe6BlswdwKmv
        kVzEus5VJSzmVNe9RzzSZg9KVg==
X-Google-Smtp-Source: APXvYqx5NCGdOPSkax1fRkCCdJNf/+cqGNfYZ3peCc5Ks+UpcNDvxd1/VLeJ0TQuKCJLSOxLH0I53w==
X-Received: by 2002:a1c:39c5:: with SMTP id g188mr1192131wma.167.1565679101396;
        Mon, 12 Aug 2019 23:51:41 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id f70sm562760wme.22.2019.08.12.23.51.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 23:51:40 -0700 (PDT)
Date:   Tue, 13 Aug 2019 08:51:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190813065140.GH2428@nanopsycho>
References: <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
 <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
 <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
 <20190812083139.GA2428@nanopsycho>
 <CAJieiUhqAvqvxDZk517hWQP4Tx3Hk2PT7Yjq6NSGk+pB_87q8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJieiUhqAvqvxDZk517hWQP4Tx3Hk2PT7Yjq6NSGk+pB_87q8A@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 12, 2019 at 05:13:39PM CEST, roopa@cumulusnetworks.com wrote:
>On Mon, Aug 12, 2019 at 1:31 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>
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
>Will the below work ?... just throwing an example for discussion:
>
>make the name list a nested list
>IFLA_ALT_NAMES
>        IFLA_ALT_NAME_OP /* ADD or DEL used with setlink */

This is exacly what I tried to avoid. Providing an OP within a message
is weird. So I wanted to do it rather in the way similar to NEIGH for
example, where you have new/del commands.


>        IFLA_ALT_NAME
>        IFLA_ALT_NAME_LIST
>
>With RTM_NEWLINK  you can specify a list to set and unset
>With RTM_SETLINK  you can specify an individual name with a add or del op
>
>notifications will always be RTM_NEWLINK with the full list.
>
>The nested attribute can be structured differently.
>
>Only thing is i am worried about increasing the size of link dump and
>notification msgs.
>
>What is the limit on the number of names again ?

No limit.
