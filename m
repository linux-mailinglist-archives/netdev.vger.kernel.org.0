Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3282FEBE01
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 07:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfKAGgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 02:36:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43021 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKAGgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 02:36:09 -0400
Received: by mail-wr1-f67.google.com with SMTP id n1so8668170wra.10
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 23:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sTsFPxq/pFRaCDUGOe6EaSDY4YEd+sF1TFTYdLuGqv8=;
        b=phIHR9+BMDI2dmrMMiMdOfsQufBWg1UDBua/gtnkjskYfIsemwPfYEzb9gDmR/mt0q
         G9mwgGYBWMfTSa8vRyz32NKE41CHwN5/kZZHbWOyPwwxiS5tTIsvPMEjzp3X4ToP1A+I
         Fu6h+W+AIe3fD57DJrjTIUEMFsRp5VyFkaw0nxM7azgGoEpAQ4YW60YZhULFyTS9mwQQ
         Ak9qbPg4rqRJkI8QgUrsQN8W8Z0DJiQ7BqJF4qn8WUe37U790jrU9I43hI5pZMXWwg6v
         G/gGtq1vkzoIZuEShioffaa5ghf2YHivLycRdE4rtH+wUrYXrP0AFHKPajGaYlBoa4CZ
         0BnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sTsFPxq/pFRaCDUGOe6EaSDY4YEd+sF1TFTYdLuGqv8=;
        b=oTj7/I8ptu+WhwJvsaBEJopAMLergr+lOYyHHzoD3RWxsd+V4HIV4fRJ4CQohAk+yp
         WaPvJJPkUUs8k5HWyE6QixUYTgT05YCCrK9Bb94tWN31cxPnik4POD01W6WHJ/Yt71m2
         /z1Vo00nHbKMCU/5kW1XXW1hks00ZorQ6Us1fePjtdkW2N9zLu/umdLSOexf32X9h61L
         TDC93998770dn33CPYfyANJ1LX9m7lEmXT6fYBZRxcHxUMQS2cZJP078fnxM5CW1ZFyD
         dzbeahKpI9oo3bSKbzhWpco3KHt+Q8QeO7pTM/pwINs2FiU0+FZWi4ei5Dr+7pxZ0Al8
         RPNQ==
X-Gm-Message-State: APjAAAXbNectnEArQ8P/lR6ZA6HiCaNVXp3flXUUU6BtnHS9JX5QXxtO
        0b+3paf44m0GmVYjmGsNaPAzBg==
X-Google-Smtp-Source: APXvYqw8Wwchqeniuh3KoDykbJbaMs0xktXpxYXyjnVchFsMzc2tNVJqTf0l892HG1Yh3P7mJ6gy0Q==
X-Received: by 2002:adf:f989:: with SMTP id f9mr9100485wrr.163.1572590166880;
        Thu, 31 Oct 2019 23:36:06 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id j15sm5167285wrt.78.2019.10.31.23.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 23:36:06 -0700 (PDT)
Date:   Fri, 1 Nov 2019 07:36:04 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, rong.a.chen@intel.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] selftests: bpf: don't try to read files without
 read permission
Message-ID: <20191101063604.GB3209@nanopsycho.orion>
References: <20191015100057.19199-1-jiri@resnulli.us>
 <20191031163535.2737f250@cakuba.netronome.com>
 <20191031164057.6c1b486a@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031164057.6c1b486a@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 01, 2019 at 12:40:57AM CET, jakub.kicinski@netronome.com wrote:
>On Thu, 31 Oct 2019 16:35:35 -0700, Jakub Kicinski wrote:
>> On Tue, 15 Oct 2019 12:00:56 +0200, Jiri Pirko wrote:
>> > From: Jiri Pirko <jiri@mellanox.com>
>> > 
>> > Recently couple of files that are write only were added to netdevsim
>> > debugfs. Don't read these files and avoid error.
>> > 
>> > Reported-by: kernel test robot <rong.a.chen@intel.com>
>> > Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> > ---
>> >  tools/testing/selftests/bpf/test_offload.py | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> > 
>> > diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
>> > index 15a666329a34..c44c650bde3a 100755
>> > --- a/tools/testing/selftests/bpf/test_offload.py
>> > +++ b/tools/testing/selftests/bpf/test_offload.py
>> > @@ -312,7 +312,7 @@ class DebugfsDir:
>> >              if f == "ports":
>> >                  continue
>> >              p = os.path.join(path, f)
>> > -            if os.path.isfile(p):
>> > +            if os.path.isfile(p) and os.access(p, os.R_OK):  
>> 
>> Have you tested this? Looks like python always returns True here when
>> run as root, and this script requires root (and checks for it).
>
>Yeah, you definitely haven't tested this. Even if it worked we'd fall
>into the else condition and say:

Sure I tested. It worked. Odd.

>
>Exception: /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/take_snapshot is neither file nor directory
>
>> Also the fix is needed in net, not sure why you sent it to net-next.
>> 
>> >                  _, out = cmd('cat %s/%s' % (path, f))
>> >                  dfs[f] = out.strip()
>> >              elif os.path.isdir(p):  
>
