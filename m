Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64ED28ABF3
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 02:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfHMA3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 20:29:17 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:37873 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfHMA3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 20:29:16 -0400
Received: by mail-pf1-f181.google.com with SMTP id 129so3635239pfa.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 17:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T8XbxlQrq0PnCGeDuc5tsfj1ZQ+e0M84noJSZpm/Nd0=;
        b=jXNRFNW03NvP5CG+eN0ZQAQeO8IL48piCRngdOc0OZyE2Xtsnjmnln1nQV8J+l0sxe
         /Rb47i4zD/aGCE6jKRNE/qBojKWy7CKlKsy8PaB60JtiQJ8YjD9vo0j10lLyTEAXf7ao
         H0JgcYZDnpd1t+zKzIt1BqOAGWaFElsPmGMhGuCbB7H2ClN4OfPUUKnFTt+yq2ISg34P
         kBxiBSfqbElBIpv8/3HcEahRPAJ1JoLLe2EJU64S4XEfdFix1vH/SVRAUQzYYYUA3Oiv
         rBc/wHwWnodTfwJkT/GUUd7+1Y45QPMUarZRJHk/hjXKUF2hLhPTjW1c07Jj/drprNoY
         mTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T8XbxlQrq0PnCGeDuc5tsfj1ZQ+e0M84noJSZpm/Nd0=;
        b=mofAJ5xuPeFI0JI9gLGKICxuVZm1oVk7y7dvlaH9BJG4uHFHoryyVOY4MPelHW2Jh+
         4URA8DlSfEqiiglq9w1zBLA7iqJo8kxf0uajMiRXrQN+3HpLE3dNXZ1pWm3ufLyRLjus
         KzCjeCBVR6lqfiXg1Ufsv6rio/dtPp16B5kcLpWLjy2jJzQc8Zh5PfRoWmq2fSZ4DVWS
         lg+pFAkQx/E0od092XouHW8bSJkiZzwqDd1AHrYNxOLHe8Ydw7X4MCCjaSpQgzyJqfOt
         KKIcXKF2M4+gkZ/KrcfXhdTnFQL8jd4hy0MFODX6OpUUPOWN3tJtzTcC7imNLQCb72e+
         mr2w==
X-Gm-Message-State: APjAAAVEv1e1X2gXYoYeIOqYhesQ85ONq60A2KXKcP35gvpwfbWn+JJC
        0/sWlRFS/+lPPuSy+WKX9+U=
X-Google-Smtp-Source: APXvYqzNFr0bCYm1OTuKAMxzJyHYhyB9bSddGrvxJqKyJhcRzS1IzIRPcPFaL/VoSWe4HTnf6/2b+A==
X-Received: by 2002:a17:90a:bc06:: with SMTP id w6mr898541pjr.124.1565656156292;
        Mon, 12 Aug 2019 17:29:16 -0700 (PDT)
Received: from [172.27.227.188] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id j6sm761825pjd.19.2019.08.12.17.29.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 17:29:15 -0700 (PDT)
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
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
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
 <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
 <20190812083139.GA2428@nanopsycho>
 <CAJieiUhqAvqvxDZk517hWQP4Tx3Hk2PT7Yjq6NSGk+pB_87q8A@mail.gmail.com>
 <20190812144310.442869de@cakuba.netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <52dd953a-d0c7-0086-5faa-18134f033c0b@gmail.com>
Date:   Mon, 12 Aug 2019 18:29:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190812144310.442869de@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/19 3:43 PM, Jakub Kicinski wrote:
> Is not adding commands better because it's easier to deal with the
> RTM_NEWLINK notification? I must say it's unclear from the thread why
> muxing the op through RTM_SETLINK is preferable. IMHO new op is
> cleaner, do we have precedent for such IFLA_.*_OP-style attributes?

An alternative name for a link is not a primary object; it is only an
attribute of a link and links are manipulated through RTM_*LINK commands.
