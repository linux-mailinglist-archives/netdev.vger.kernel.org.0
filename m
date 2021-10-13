Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864B242C308
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbhJMO0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237386AbhJMO0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 10:26:46 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CA1C061767;
        Wed, 13 Oct 2021 07:24:42 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id a73so2514876pge.0;
        Wed, 13 Oct 2021 07:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GgLeny9RRCUIQprwdlxJZjp2yCfEMCCi7d+W6a4O/34=;
        b=c6efQ+uip1bfCO7VbsP9ygZemfROoF+/0+ywqEsLqaQ/ALaXRmxDLs17OCdRGAZQ04
         hgZS7JVOGgAOzgwnrH09kPWdPeGa2InWnAZuP+kjoZjaKAYEBTfAFfDYJj8p24KU3eaJ
         ycF7boqOQKcgyZLOY1MLqZVDbyrbN/prq9T97QnGLURIi33pVS2DP4xb0MgNiXGIaiJ5
         5FzdXHhBDTWlv8ciYF9Ee0C0UvKNg9HqAGRV27WRRSnYMTf7VoKBTqtBRMg9ucGNh7KN
         NiHDOLjsG8eJ5AIcjF3aenDzCz9itNWpJiXgpnWgFXLmnY/iRMOBPO1SJuqCZHg/ZxJH
         Y6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GgLeny9RRCUIQprwdlxJZjp2yCfEMCCi7d+W6a4O/34=;
        b=NMVJFnR46lFnoaCyPLCprTu207M1HQXV1uPf+nxlyGeV3e5ApbtY2m5Tne4VtLYUmj
         3wd12iDe0WjQH4GsCGDCjUefkS3Xl8Q/kn0VliZH7PceBg20rmvfaMDP80uoDMpgsWN6
         mcegzpL5ybJ1k3Uga3DyHtCfMpEw8lMd0+yEw7Mur8tC4pwa/oUbbvs5ca6+GWXk5Iv0
         9B4E80JrrRfkUMXiQLsqFpCxmxsHDwaGpEmkfmlRdJOt1R4N8GumLH+QPZe98ncdLiW7
         rJr1x5kj3VOtOmVc7Y2li8P2rontlO68pVmK/FABu5yGdr4TiQ552EfK/ee5+ixQGZFf
         MKzw==
X-Gm-Message-State: AOAM533TEzchCOcTZm7yZ1kJ1TSU2QNGuna15rdFqSSoN156mHDmwp/k
        P4XK1ru1L8VfJJQ+CVf7X2Y=
X-Google-Smtp-Source: ABdhPJzcK8fBuj9NavxJ7Qe+4cRzqSVGipG1r2hfRp4nF7Wg+prGM0c+0WfWTbk4G/iNppe4Ef5lEg==
X-Received: by 2002:a05:6a00:2388:b0:44d:4b5d:d5e with SMTP id f8-20020a056a00238800b0044d4b5d0d5emr7076985pfc.80.1634135082433;
        Wed, 13 Oct 2021 07:24:42 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id e6sm14770750pgf.59.2021.10.13.07.24.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 07:24:42 -0700 (PDT)
Subject: Re: [PATCH V7 5/9] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call
 ghcb hv call out of sev code
To:     Borislav Petkov <bp@alien8.de>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        konrad.wilk@oracle.com, hch@lst.de, robin.murphy@arm.com,
        joro@8bytes.org, parri.andrea@gmail.com, dave.hansen@intel.com,
        Hikys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, kuba@kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, jroedel@suse.de,
        brijesh.singh@amd.com, Tianyu.Lan@microsoft.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, tj@kernel.org, aneesh.kumar@linux.ibm.com,
        saravanand@fb.com, hannes@cmpxchg.org, rientjes@google.com,
        michael.h.kelley@microsoft.com
References: <20211006063651.1124737-1-ltykernel@gmail.com>
 <20211006063651.1124737-6-ltykernel@gmail.com>
 <9b5fc629-9f88-039c-7d5d-27cbdf6b00fd@gmail.com> <YWRyvD413h+PwU9B@zn.tnic>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <5a0b9de8-e133-c17b-bc0d-93bfb593c48f@gmail.com>
Date:   Wed, 13 Oct 2021 22:24:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YWRyvD413h+PwU9B@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/2021 1:22 AM, Borislav Petkov wrote:
> On Mon, Oct 11, 2021 at 10:42:18PM +0800, Tianyu Lan wrote:
>> Hi @Tom and Borislav:
>>       Please have a look at this patch. If it's ok, could you give your ack.
> 
> I needed to do some cleanups in that area first:
> 
> https://lore.kernel.org/r/YWRwxImd9Qcls/Yy@zn.tnic
> 
> Can you redo yours ontop so that you can show what exactly you need
> exported for HyperV?
> 
> Thx.

Hi Borislav :
	Please check whether the following change based on you patch is
ok for you.
---
x86/sev-es: Expose __sev_es_ghcb_hv_call() to call ghcb hv call out of 
sev code

     Hyper-V also needs to call ghcb hv call to write/read MSR in 
Isolation VM.
     So expose __sev_es_ghcb_hv_call() to call it in the Hyper-V code.

     Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index fa5cd05d3b5b..295c847c3cd4 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -81,12 +81,23 @@ static __always_inline void sev_es_nmi_complete(void)
                 __sev_es_nmi_complete();
  }
  extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
+extern enum es_result __sev_es_ghcb_hv_call(struct ghcb *ghcb,
+                                           struct es_em_ctxt *ctxt,
+                                           u64 exit_code, u64 exit_info_1,
+                                           u64 exit_info_2);
  #else
  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
  static inline void sev_es_ist_exit(void) { }
  static inline int sev_es_setup_ap_jump_table(struct real_mode_header 
*rmh) { return 0; }
  static inline void sev_es_nmi_complete(void) { }
  static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
+static inline enum es_result
+__sev_es_ghcb_hv_call(struct ghcb *ghcb,
+                     u64 exit_code, u64 exit_info_1,
+                     u64 exit_info_2)
+{
+       return ES_VMM_ERROR;
+}
  #endif

  #endif
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index ea9abd69237e..08c97cb057fa 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -124,10 +124,14 @@ static enum es_result verify_exception_info(struct 
ghcb *ghcb, struct es_em_ctxt
         return ES_VMM_ERROR;
  }

-static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
-                                         struct es_em_ctxt *ctxt,
-                                         u64 exit_code, u64 exit_info_1,
-                                         u64 exit_info_2)
+/*
+ * __sev_es_ghcb_hv_call() is also used in the other platform code(e.g
+ * Hyper-V).
+ */
+enum es_result __sev_es_ghcb_hv_call(struct ghcb *ghcb,
+                                    struct es_em_ctxt *ctxt,
+                                    u64 exit_code, u64 exit_info_1,
+                                    u64 exit_info_2)
  {
         /* Fill in protocol and format specifiers */
         ghcb->protocol_version = GHCB_PROTOCOL_MAX;
@@ -137,12 +141,22 @@ static enum es_result sev_es_ghcb_hv_call(struct 
ghcb *ghcb,
         ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
         ghcb_set_sw_exit_info_2(ghcb, exit_info_2);

-       sev_es_wr_ghcb_msr(__pa(ghcb));
         VMGEXIT();

         return verify_exception_info(ghcb, ctxt);
  }

+static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
+                                         struct es_em_ctxt *ctxt,
+                                         u64 exit_code, u64 exit_info_1,
+                                         u64 exit_info_2)
+{
+       sev_es_wr_ghcb_msr(__pa(ghcb));
+
+       return __sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, exit_info_1,
+                                    exit_info_2);
+}
+
  /*
   * Boot VC Handler - This is the first VC handler during boot, there 
is no GHCB
   * page yet, so it only supports the MSR based communication with the
(END)


Thanks.


