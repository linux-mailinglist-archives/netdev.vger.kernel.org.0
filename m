Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83BDB1980
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 10:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387451AbfIMIVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 04:21:24 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:41259 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387435AbfIMIVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 04:21:24 -0400
Received: by mail-wr1-f52.google.com with SMTP id h7so30132489wrw.8
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 01:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IT3lbS0nlgM/zpV4Tjq1wwmFa4Su9XjodZJMOCVhN1g=;
        b=TsFAShQFjcvPJtAvVaMvpPLyBvXiQ+AnTA3YsH0mDGmOuHqakog4N2iCZE7ltf54QR
         2mvV+E5wiNwyTp2e87frZLtQZoyJxapg9hylO6U80+T0c6cg+SolL6x1PYIx84sFLjVC
         KjyQtW5pDVPyYF9XHOwoxl229Wwk0eI67Xq1Z3rAD74L2RT5eml6MGettrb1S//WnTxC
         fEO8InXnl7gty7F2I8u5C92jifTA7pOtjWzCyk+NorcoCixJ6d2SWDbP4vJZj3UpkWaE
         Ke4b+eubiO0OQg4H56paayAobF7Xo1tuNRtmP1Mb/6Cku2CyV0oyexSND/RInVUrgGHi
         Epcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IT3lbS0nlgM/zpV4Tjq1wwmFa4Su9XjodZJMOCVhN1g=;
        b=uYhIOyCF9QBOlKdbAvZxZwmKn+c/+lnjwiFF9S29BykkwttRAp5NXtAteHG7YtJ8Qz
         hsVPp2+FeN71mhweYcMhpWjnvK8Ds+KenwFcFfLzB74ozh9+E1stCuuVGFz7mB+USN9D
         Jdwug7drRJL3Y5cKHLpU8Cs/gTyHsNWxG4CL9uKVQIRzYaCsTkcaK+RCAWOW5eSqqKT4
         F+lTlfI8mlbMpWVNl7A8lhcQpUmxuuKP4Sb5Rf5rHRVzjTuw2+BLN5FJOsw0AgYMaask
         ikFNlo8256IAp4UWX5XwSMaIDV3C8Xb1YLNySSjpoIIWmwJMMgOt06XvrkthsuRKZXvC
         cd8w==
X-Gm-Message-State: APjAAAV8T2kh5MvlUnDqaLWJ4SGPp+LAD/4NcKEjqwxbH9qqpf9ZjuZo
        1OWamcocKjEtBWLKJWe1T5GjFw==
X-Google-Smtp-Source: APXvYqyOGIBwelqwA0dJT84XTdHl9/5HBkBlURDaSTjKGWmcLrs8S+D0EulQabA+ur3LuLKOkAOjsQ==
X-Received: by 2002:adf:ef05:: with SMTP id e5mr7282184wro.127.1568362882374;
        Fri, 13 Sep 2019 01:21:22 -0700 (PDT)
Received: from localhost (ip-213-220-255-83.net.upcbroadband.cz. [213.220.255.83])
        by smtp.gmail.com with ESMTPSA id x5sm38310626wrg.69.2019.09.13.01.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 01:21:21 -0700 (PDT)
Date:   Fri, 13 Sep 2019 10:21:21 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190913082121.GD2330@nanopsycho>
References: <20190827070808.GA2250@nanopsycho>
 <20190827.012242.418276717667374306.davem@davemloft.net>
 <20190827093525.GB2250@nanopsycho>
 <CAJieiUjpE+o-=x2hQcsKQJNxB8O7VLHYw2tSnqzTFRuy_vtOxw@mail.gmail.com>
 <20190828070711.GE2312@nanopsycho>
 <CAJieiUiipZY3A+04Po=WnvgkonfXZxFX2es=1Q5dq1Km869Obw@mail.gmail.com>
 <20190829052620.GK29594@unicorn.suse.cz>
 <CAJieiUgGY4amm_z1VGgBF-3WZceah+R5OVLEi=O2RS8RGpC9dg@mail.gmail.com>
 <20190830170342.GR2312@nanopsycho>
 <20190912115942.GC7621@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912115942.GC7621@nanopsycho.orion>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 12, 2019 at 01:59:42PM CEST, jiri@resnulli.us wrote:
>Fri, Aug 30, 2019 at 07:03:42PM CEST, jiri@resnulli.us wrote:
>>Fri, Aug 30, 2019 at 04:35:23PM CEST, roopa@cumulusnetworks.com wrote:
>
>[...]
>
>>>
>>>so to summarize, i think we have discussed the following options to
>>>update a netlink list attribute so far:
>>>(a) encode an optional attribute/flag in the list attribute in
>>>RTM_SETLINK to indicate if it is a add or del

If we do this, how do you imagine this is going to be used from cmdline?
ip link set ? How exactly?

Thanks!


>>>(b) Use a flag in RTM_SETLINK and RTM_DELINK to indicate add/del
>>>(close to bridge vlan add/del)
>>
>>Nope, bridge vlan add/del is done according to the cmd, not any flag.
>>
>>
>>>(c) introduce a separate generic msg type to add/del to a list
>>>attribute (IIUC this does need a separate msg type per subsystem or
>>>netlink API)
>
>Getting back to this, sorry.
>
>Thinking about it for some time, a,b,c have all their issues. Why can't
>we have another separate cmd as I originally proposed in this RFC? Does
>anyone have any argument against it? Could you please describe?
>
>Because otherwise, I don't feel comfortable going to any of a,b,c :(
>
>Thanks!
>
