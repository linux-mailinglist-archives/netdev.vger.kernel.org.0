Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D1256832A
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 11:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbiGFJN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 05:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiGFJM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 05:12:26 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01274237CE;
        Wed,  6 Jul 2022 02:09:27 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id v6so10587165qkh.2;
        Wed, 06 Jul 2022 02:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vxiJQMa2a6ScrGhpzgzV+Tp/u0829jq0BqEczNesPFg=;
        b=o5doXy6hGI66V3VIS5tzxrBUc2XInriDflyet203f8a6lpypa36zQtQtV2M0B4mN+m
         LyUa6Hlr7zBWOwlrlfa/Vmk6gFSzsJnnGqRdjOURDPzefqTJzGgVi+M1iDn7QSNcAbwA
         ZxmYxzAO0vicXMCMAgZxEFcshx+08cRa+aeyZ76nqJw6mhaXWtXQ7BDS1XsPjnaO4Fi8
         nGQl10+JvuZiY+LJv5uglQFkyzzUHGpxG0A4EE+T56VRjncNJDhhjrH8CdXyrUxJ2SMw
         eJvghUk/u1iSD923K7V3eWGwg+3PkhBgjFdskqMbDORqT/Y4TCKYYgW1IpAKEkWC3VON
         AfdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vxiJQMa2a6ScrGhpzgzV+Tp/u0829jq0BqEczNesPFg=;
        b=SD8I+IZCzfXFRPmcZBCAmqHEpxLTNeRJbi96OotCHk/C7Sd8QH5FL301bsMeIebgFA
         uubc65uOnKGk9rByKtlugtNnaPBLvKFZHSyUWnP31Munbtiq3my3XFBwdPYq4Yo+K/TB
         Q8wRv8oH5Qgpkx07Gh9di4DsQHtZaqremqt8DrhLhaiRf2EFff3Y+PiAccwyqU7XH1RL
         BLvkK9OqaMv2cBCXvPTPMRY8BPqBCLdZ0gRrSTHs6KbYWXPGxgmwRVszWwGxtgwUvrko
         Uyd/DenHC3zZWW4VFkEFOwP6On3JsATcvdXPcPefT6egkKa2q8NYJHAwqCiY/zUqHguy
         YuyA==
X-Gm-Message-State: AJIora9n3pb6rNk5fie+U6FG5orwgBY2w71keH1623dJxCOhhWCRpoDw
        wZCWKIEitSGPHIjMqTIis8E=
X-Google-Smtp-Source: AGRyM1u05qeTfN+/HiKZW7k0MqRT9HazAjC+mvjUvYovZJgAZylA2VnE3JRJMa+53lspajs/Ln8Qjw==
X-Received: by 2002:a05:620a:254d:b0:6ab:84b8:25eb with SMTP id s13-20020a05620a254d00b006ab84b825ebmr26293265qko.383.1657098566068;
        Wed, 06 Jul 2022 02:09:26 -0700 (PDT)
Received: from [10.176.68.61] ([192.19.148.250])
        by smtp.gmail.com with ESMTPSA id a21-20020a05620a16d500b006a7502d0070sm27504807qkn.21.2022.07.06.02.09.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 02:09:25 -0700 (PDT)
Message-ID: <0aa190fb-b761-6114-93c0-347aa5950a2e@gmail.com>
Date:   Wed, 6 Jul 2022 11:09:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 04/13] tracing/brcm: Use the new __vstring() helper
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        kernel test robot <lkp@intel.com>
Cc:     linux-kernel@vger.kernel.org, kbuild-all@lists.01.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
References: <20220705224749.622796175@goodmis.org>
 <202207061019.0zRrehFH-lkp@intel.com>
 <20220705225049.665db869@gandalf.local.home>
From:   Arend Van Spriel <aspriel@gmail.com>
In-Reply-To: <20220705225049.665db869@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/2022 4:50 AM, Steven Rostedt wrote:
> On Wed, 6 Jul 2022 10:35:50 +0800
> kernel test robot <lkp@intel.com> wrote:
> 
>> Hi Steven,
>>
>> Thank you for the patch! Perhaps something to improve:
>>
>> [auto build test WARNING on rostedt-trace/for-next]
>> [also build test WARNING on wireless-next/main wireless/main linus/master v5.19-rc5 next-20220705]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch]
>>
> 
> 
>> If you fix the issue, kindly add following tag where applicable
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All warnings (new ones prefixed by >>):
> 
> OK, let's look at all the warnings.
> 
>>
>>     In file included from include/trace/define_trace.h:102,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h:133,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:12:
>>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'trace_event_get_offsets_brcmf_err':
>>>> include/trace/trace_events.h:261:16: warning: function 'trace_event_get_offsets_brcmf_err' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> 
>   1. "might be a candidate for 'gnu_printf' format attribute"
> 
>>       261 |         struct trace_event_raw_##call __maybe_unused *entry;            \
>>           |                ^~~~~~~~~~~~~~~~
>>     include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>>        40 |         DECLARE_EVENT_CLASS(name,                              \
>>           |         ^~~~~~~~~~~~~~~~~~~
>>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:31:1: note: in expansion of macro 'TRACE_EVENT'
>>        31 | TRACE_EVENT(brcmf_err,
>>           | ^~~~~~~~~~~
>>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'trace_event_get_offsets_brcmf_dbg':
>>>> include/trace/trace_events.h:261:16: warning: function 'trace_event_get_offsets_brcmf_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> 
>   2. "might be a candidate for 'gnu_printf' format attribute"
> 
>>       261 |         struct trace_event_raw_##call __maybe_unused *entry;            \
>>           |                ^~~~~~~~~~~~~~~~
>>     include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>>        40 |         DECLARE_EVENT_CLASS(name,                              \
>>           |         ^~~~~~~~~~~~~~~~~~~
>>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:45:1: note: in expansion of macro 'TRACE_EVENT'
>>        45 | TRACE_EVENT(brcmf_dbg,
>>           | ^~~~~~~~~~~
>>     In file included from include/trace/define_trace.h:102,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h:133,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:12:
>>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'trace_event_raw_event_brcmf_err':
>>     include/trace/trace_events.h:386:16: warning: function 'trace_event_raw_event_brcmf_err' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> 
>   3. "might be a candidate for 'gnu_printf' format attribute"
> 
>>       386 |         struct trace_event_raw_##call *entry;                           \
>>           |                ^~~~~~~~~~~~~~~~
>>     include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>>        40 |         DECLARE_EVENT_CLASS(name,                              \
>>           |         ^~~~~~~~~~~~~~~~~~~
>>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:31:1: note: in expansion of macro 'TRACE_EVENT'
>>        31 | TRACE_EVENT(brcmf_err,
>>           | ^~~~~~~~~~~
>>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'trace_event_raw_event_brcmf_dbg':
>>     include/trace/trace_events.h:386:16: warning: function 'trace_event_raw_event_brcmf_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> 
>   4. "might be a candidate for 'gnu_printf' format attribute"
> 
>>       386 |         struct trace_event_raw_##call *entry;                           \
>>           |                ^~~~~~~~~~~~~~~~
>>     include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>>        40 |         DECLARE_EVENT_CLASS(name,                              \
>>           |         ^~~~~~~~~~~~~~~~~~~
>>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:45:1: note: in expansion of macro 'TRACE_EVENT'
>>        45 | TRACE_EVENT(brcmf_dbg,
>>           | ^~~~~~~~~~~
>>     In file included from include/trace/define_trace.h:103,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h:133,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:12:
>>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'perf_trace_brcmf_err':
>>     include/trace/perf.h:64:16: warning: function 'perf_trace_brcmf_err' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> 
>   5. "might be a candidate for 'gnu_printf' format attribute"
> 
>>        64 |         struct hlist_head *head;                                        \
>>           |                ^~~~~~~~~~
>>     include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>>        40 |         DECLARE_EVENT_CLASS(name,                              \
>>           |         ^~~~~~~~~~~~~~~~~~~
>>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:31:1: note: in expansion of macro 'TRACE_EVENT'
>>        31 | TRACE_EVENT(brcmf_err,
>>           | ^~~~~~~~~~~
>>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'perf_trace_brcmf_dbg':
>>     include/trace/perf.h:64:16: warning: function 'perf_trace_brcmf_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> 
>   6. "might be a candidate for 'gnu_printf' format attribute"
> 
>>        64 |         struct hlist_head *head;                                        \
>>           |                ^~~~~~~~~~
>>     include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>>        40 |         DECLARE_EVENT_CLASS(name,                              \
>>           |         ^~~~~~~~~~~~~~~~~~~
>>     drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:45:1: note: in expansion of macro 'TRACE_EVENT'
>>        45 | TRACE_EVENT(brcmf_dbg,
>>           | ^~~~~~~~~~~
>> --
>>     In file included from include/trace/define_trace.h:102,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h:82,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.h:38,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.c:22:
>>     drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h: In function 'trace_event_get_offsets_brcms_dbg':
>>>> include/trace/trace_events.h:261:16: warning: function 'trace_event_get_offsets_brcms_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> 
>   7. "might be a candidate for 'gnu_printf' format attribute"
> 
>>       261 |         struct trace_event_raw_##call __maybe_unused *entry;            \
>>           |                ^~~~~~~~~~~~~~~~
>>     include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>>        40 |         DECLARE_EVENT_CLASS(name,                              \
>>           |         ^~~~~~~~~~~~~~~~~~~
>>     drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h:59:1: note: in expansion of macro 'TRACE_EVENT'
>>        59 | TRACE_EVENT(brcms_dbg,
>>           | ^~~~~~~~~~~
>>     In file included from include/trace/define_trace.h:102,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h:82,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.h:38,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.c:22:
>>     drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h: In function 'trace_event_raw_event_brcms_dbg':
>>     include/trace/trace_events.h:386:16: warning: function 'trace_event_raw_event_brcms_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> 
>   8. "might be a candidate for 'gnu_printf' format attribute"
> 
> 
>>       386 |         struct trace_event_raw_##call *entry;                           \
>>           |                ^~~~~~~~~~~~~~~~
>>     include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>>        40 |         DECLARE_EVENT_CLASS(name,                              \
>>           |         ^~~~~~~~~~~~~~~~~~~
>>     drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h:59:1: note: in expansion of macro 'TRACE_EVENT'
>>        59 | TRACE_EVENT(brcms_dbg,
>>           | ^~~~~~~~~~~
>>     In file included from include/trace/define_trace.h:103,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h:82,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.h:38,
>>                      from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.c:22:
>>     drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h: In function 'perf_trace_brcms_dbg':
>>     include/trace/perf.h:64:16: warning: function 'perf_trace_brcms_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
> 
>   9. "might be a candidate for 'gnu_printf' format attribute"
> 
>>        64 |         struct hlist_head *head;                                        \
>>           |                ^~~~~~~~~~
>>     include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>>        40 |         DECLARE_EVENT_CLASS(name,                              \
>>           |         ^~~~~~~~~~~~~~~~~~~
>>     drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h:59:1: note: in expansion of macro 'TRACE_EVENT'
>>        59 | TRACE_EVENT(brcms_dbg,
>>           | ^~~~~~~~~~~
>>
>>
>> vim +261 include/trace/trace_events.h
>>
>> 55de2c0b5610cb include/trace/trace_events.h Masami Hiramatsu         2021-11-22  253
>> 091ad3658e3c76 include/trace/ftrace.h       Ingo Molnar              2009-11-26  254  #undef DECLARE_EVENT_CLASS
>> 091ad3658e3c76 include/trace/ftrace.h       Ingo Molnar              2009-11-26  255  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
>> d0ee8f4a1f5f3d include/trace/trace_events.h Steven Rostedt (Red Hat  2015-05-13  256) static inline notrace int trace_event_get_offsets_##call(		\
>> 62323a148fbeb0 include/trace/trace_events.h Steven Rostedt (Red Hat  2015-05-13  257) 	struct trace_event_data_offsets_##call *__data_offsets, proto)	\
>> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  258  {									\
>> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  259  	int __data_size = 0;						\
>> 114e7b52dee69c include/trace/ftrace.h       Filipe Brandenburger     2014-02-28  260  	int __maybe_unused __item_length;				\
>> a7237765730a10 include/trace/trace_events.h Steven Rostedt (Red Hat  2015-05-13 @261) 	struct trace_event_raw_##call __maybe_unused *entry;		\
>> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  262  									\
>> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  263  	tstruct;							\
>> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  264  									\
>> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  265  	return __data_size;						\
>> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  266  }
>> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  267
>>
> 
> Really? 9 warnings about something that *MIGHT* be a candidate for
> gnu_printf format attribute?  This is a macro that expanded into something
> that could possibly use the printf format, but is nested deep in macro
> magic.
> 
> Can we please shut this up?

Need a vote? Here it is: +1

Regards,
Arend
