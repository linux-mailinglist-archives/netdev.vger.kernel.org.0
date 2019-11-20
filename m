Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA6010319C
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 03:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfKTCdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 21:33:16 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38491 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfKTCdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 21:33:16 -0500
Received: by mail-pj1-f68.google.com with SMTP id f7so3491633pjw.5;
        Tue, 19 Nov 2019 18:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T2WeYV80OjrUzdOrjzmYOJ2I4YAFnUZSAbDhvntIAp8=;
        b=FyNaE1UKSW58uV3K2ZK1Z09ArgGHMkKMntVt5f7bbcWIdrutXpcS2Uu7XX7r8VrMDs
         A4A2SH7N48r1uuVnos1Ph+0TQ6aqHNfXBUiZjebIU9eSk3PLQpkpAXNv2u4f1zO3IiQQ
         Jyt/VBPMhfU8sJoc/zFUAlGj37DH7h8xyvTHobHykZxjxU5dnO2YQwdqyI8MnY4DQW4e
         T2Cq7hGYHDCLd3fF9vt4dztO2+JdgZovF1760mCT+vHIhHkeUHCmGse2cKHeEc7+UiBL
         iUWB0Q2W13XicZjIcGFW9cieW0ZNHPZGC+XcDN3SPJzGhPCiW9IGkBI4o3qOPySQopo9
         xd6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T2WeYV80OjrUzdOrjzmYOJ2I4YAFnUZSAbDhvntIAp8=;
        b=nlyObrURcOWFV/gSPcXA0ukHqmmswrmBkYWGh0G5tSmv+Kw+WIeINw1ELvkeQo1457
         oQ22PIrDLKu3rfAsXrFMZU2rkSm3ixFKEyywk0ZTTCLfe+1nXNPXjKLgZ9fajdM18Yh8
         6dSnAjGo6zl8o88dyFxH66afM3jYcn7esDuC7qfRreaYS+ja2WGeshXJEFsiPA71A+wh
         9nKdWzwjoVJpt1JCG4svY8gutXDkYEYxhsN8BaPUB7VmI5huLvFuYZO3FbLRmosUGRfi
         VIp4TbqgN/UzDWBRw4FQJEuXyiOiLNF3WQlC9gYGCK23PNmyJlXRBNZ6/DYAv+7/WwNe
         XonA==
X-Gm-Message-State: APjAAAWgxXmUkXFAjLQuRnMMOBFvVU4zjmqxYyyo70KbYo88olEWgRQH
        erOLJd2fzvs5/EJyW4brJ54=
X-Google-Smtp-Source: APXvYqwmbEdf3pSy+UgHLOEa0MOaoeSnCCbhwfYBR1/Ae79rhLVo0glt2AoUoy5fi5dv4tcT8wyHCg==
X-Received: by 2002:a17:90a:aa8c:: with SMTP id l12mr944325pjq.92.1574217195868;
        Tue, 19 Nov 2019 18:33:15 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:3071:8113:4ecc:7f4c])
        by smtp.googlemail.com with ESMTPSA id y24sm28713411pfr.116.2019.11.19.18.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 18:33:15 -0800 (PST)
Subject: Re: [PATCH iproute2-next] rdma: Rewrite custom JSON and prints logic
 to use common API
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Kalir <idok@mellanox.com>, netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leon Romanovsky <leonro@mellanox.com>
References: <20191118083530.51788-1-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <afe19f2b-a2dc-f1ad-9186-0505d7ea61ca@gmail.com>
Date:   Tue, 19 Nov 2019 19:33:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191118083530.51788-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 1:35 AM, Leon Romanovsky wrote:
> From: Ido Kalir <idok@mellanox.com>
> 
> Instead of doing open-coded solution to generate JSON and prints, let's
> reuse existing infrastructure and APIs to do the same as ip/*.
> 
> Before this change:
>  if (rd->json_output)
>      jsonw_uint_field(rd->jw, "sm_lid", sm_lid);
>  else
>      pr_out("sm_lid %u ", sm_lid);
> 
> After this change:
>  print_uint(PRINT_ANY, "sm_lid", "sm_lid %u ", sm_lid);
> 
> All the print functions are converted to support color but for now the
> type of color is COLOR_NONE. This is done as a preparation to addition
> of color enable option. Such change will require rewrite of command line
> arguments parser which is out-of-scope for this patch.
> 
> Signed-off-by: Ido Kalir <idok@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Applied to iproute2-next. Thank you for doing this!

Now we just devlink to be converted.

