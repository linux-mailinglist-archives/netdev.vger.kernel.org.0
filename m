Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7238B8B02C
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfHMGxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:53:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51769 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMGxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:53:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so441948wma.1
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 23:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wnCKTSMh2UPkxCKgjSjC/qCWpIE7zXASU03NKoAxyDI=;
        b=Gmd64QTRApTElhGDCfs7r0ZLjZpFkkzoYRt9pm1iX/uJeT4ht1VomIcyefV3jwJvkG
         vCSAC9M5zXWrurR4QnPdyNGl+1YYU4EgEJgTVnUnpOydYXB1M2eh9VtMB2cUSKYqO/3H
         ETyzYMrTdMzLr7EDVeaM18V6J+99//N0y4z9dt6qzamxag3UsbK/z6mj9PZGr8/JHrQB
         upMlywxCMa8W6fiNBnomUVi2tgjFuqZ4eQ/hOuLOt75UdBU5xNMZArev0PkuiMYQdn0d
         oguaLhdQzEaoWHguB6B8vgNjikFOkfTLyCefjqRJCwavfJyobn74FdbfPQbOADN1+qrn
         lpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wnCKTSMh2UPkxCKgjSjC/qCWpIE7zXASU03NKoAxyDI=;
        b=BqtOa4qbFkhf3SLh6Vk6sySkHBmOadt5EhMecwlVPKJ6u2ZrtLHssKUrM8u2I1oFIl
         tLYapk5Pv2n78n2gpJr+nqO0dFICJ3e4JEUyw3FHLbT3owisvnaQX+Yd35bKBoX+6jzD
         8rZ7IE9kT/6FolxOF7WZ1XmpTPbp6qErcBPbJRZnaDwL1t0axwm8OxZnryfM3SDjQ9F8
         JfL/R8MvfN4Gid/nt7HQfzIUocpExxM+nIyjtWp48DskUa/OXiW55XsS2m5/JAPfbhPk
         v6xD27NSEPVWe+L8E0nLMYPGh6Zl0IuVAhpZE8CcGbXZ4SL9dfXNg68xo8dZ1NW1qqtn
         bt/A==
X-Gm-Message-State: APjAAAVquKdzqeZxigexsVH5xIrfTSa9zDwhhksPXbvLD0qavPJ2liA6
        xsl5xHlPJZfqCrb4e+hdQNBwWg==
X-Google-Smtp-Source: APXvYqwIx+f96R0NcpEd+35qiqUlUPCJe1EZEz20vkzbTNcdKn8fpyPHVwdnZDVld0pfbJoMMNTogA==
X-Received: by 2002:a1c:f618:: with SMTP id w24mr1320152wmc.112.1565679222435;
        Mon, 12 Aug 2019 23:53:42 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id q124sm647972wma.33.2019.08.12.23.53.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 23:53:41 -0700 (PDT)
Date:   Tue, 13 Aug 2019 08:53:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190813065341.GI2428@nanopsycho>
References: <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
 <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
 <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
 <20190812083139.GA2428@nanopsycho>
 <CAJieiUhqAvqvxDZk517hWQP4Tx3Hk2PT7Yjq6NSGk+pB_87q8A@mail.gmail.com>
 <20190812144310.442869de@cakuba.netronome.com>
 <52dd953a-d0c7-0086-5faa-18134f033c0b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52dd953a-d0c7-0086-5faa-18134f033c0b@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 13, 2019 at 02:29:13AM CEST, dsahern@gmail.com wrote:
>On 8/12/19 3:43 PM, Jakub Kicinski wrote:
>> Is not adding commands better because it's easier to deal with the
>> RTM_NEWLINK notification? I must say it's unclear from the thread why
>> muxing the op through RTM_SETLINK is preferable. IMHO new op is
>> cleaner, do we have precedent for such IFLA_.*_OP-style attributes?
>
>An alternative name for a link is not a primary object; it is only an
>attribute of a link and links are manipulated through RTM_*LINK commands.

So? Still, doing the OP thing inside the message feels wrong, "primary
object" or now. Why can't the "secondary object" (whatever it is) have
separate command? What is the limitation? I'm trying to understand the
reason.
