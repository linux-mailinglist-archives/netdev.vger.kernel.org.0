Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492AD8952E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 03:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfHLBfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 21:35:01 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33324 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfHLBfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 21:35:01 -0400
Received: by mail-ot1-f65.google.com with SMTP id q20so500255otl.0
        for <netdev@vger.kernel.org>; Sun, 11 Aug 2019 18:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MjYl6nZdTPiQvVVbZ0W23UBFBzuiCwUjhIUqDO/Zg3A=;
        b=e2O1LGGe971lIacBWMw3xiJyJAMt8oV3IP2tb2v5hsnhuLZYU6QjAHxWrvwoGpA3Zy
         1bl+9YUva9pDlzrFUjsJcIjSd8Ag1bFN+5EtBy8eX9yhaJOslI7/YyHkQexIMmP2+TIr
         boW6DzS0RGjRzkICiKM9fZCafSW8f625t/0NO6MK4el2DTtPQ5TqxnsnelDj3gtRbUkZ
         Ztjcz7sHJisyn/7pWdNi/TkND+ge0ZWWoyqVVitgeCCfjVXfjeAoC7bWTmIUmw6qFyDq
         ZXZW5cB6hppFtyC9Q6yTlOoy0JT2WBrHI/ifWc5UQ+IQ8EMro6Dx+7fr3Wq+/kdioYEO
         +Xgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MjYl6nZdTPiQvVVbZ0W23UBFBzuiCwUjhIUqDO/Zg3A=;
        b=kFVjMR6ncGpbumqkhLyvv1BmkMP1Av3ZvgTcbAcCgkrClAblGD7hNS9s559UcjPk3H
         +hroj3mlGgWIe2zsEU5XfYyIjh8X2CGtu7UyMex1DVDT1eFL1jux+dQsv6GgTMsnVCIS
         pIDxXV1tXuM/i5cB/8lYY49be7BCu/Dv+oISIDMVB7J+1I8QXmEL02y1pEBXD5fAYCMo
         WFzWEd7Q4KzdgByrzjeb4ub2UUmu/oFzoat4Xb8vs/nfBDAG46ibHWYaw6BVRoCKdoiz
         Cl5c6J7QQO1Q3vO31peUFGG0shtzPA4LLZd/juXcZq2mO5pD+uem8R9cViZaZ5pJiMCR
         +f2Q==
X-Gm-Message-State: APjAAAWoDEXoztGFK2vXFCOyREZtsURCOpNZ+8+6wYfdZJeiAeJyuRax
        SB2xDM6fDl8TbxTbwUVpQhc=
X-Google-Smtp-Source: APXvYqyRxWL0tG2BQeWUGHcBurcVSp3IZo0QqxfDQf8/nTsrVAxL8hJk8MIf7/gHCkTUV/o6cerNvQ==
X-Received: by 2002:a6b:5a12:: with SMTP id o18mr17860238iob.159.1565573700135;
        Sun, 11 Aug 2019 18:35:00 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:1576:e0d9:527d:c4bb? ([2601:282:800:fd80:1576:e0d9:527d:c4bb])
        by smtp.googlemail.com with ESMTPSA id j5sm78216134iom.69.2019.08.11.18.34.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 18:34:59 -0700 (PDT)
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
 <20190810063047.GC2344@nanopsycho.orion>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
Date:   Sun, 11 Aug 2019 19:34:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190810063047.GC2344@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/19 12:30 AM, Jiri Pirko wrote:
> Could you please write me an example message of add/remove?

altnames are for existing netdevs, yes? existing netdevs have an id and
a name - 2 existing references for identifying the existing netdev for
which an altname will be added. Even using the altname as the main
'handle' for a setlink change, I see no reason why the GETLINK api can
not take an the IFLA_ALT_IFNAME and return the full details of the
device if the altname is unique.

So, what do the new RTM commands give you that you can not do with
RTM_*LINK?
