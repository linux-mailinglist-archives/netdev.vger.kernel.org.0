Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99878182A1B
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 09:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388193AbgCLIBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 04:01:42 -0400
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:55477 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387999AbgCLIBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 04:01:41 -0400
Received: from [192.168.2.10] ([46.9.234.233])
        by smtp-cloud9.xs4all.net with ESMTPA
        id CImQjXGct9Im2CImTjipFx; Thu, 12 Mar 2020 09:01:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s1;
        t=1584000098; bh=rlvXrsquCgOAoL6m3j4naIDiZk45jPg5qzfaHkH6ylc=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=S5pQfgbOLIHhQdw0W7sV5AZx/O5rbzeyPt7bFpTNkwgO8Qy0BKq+Rvjmju5L2B424
         ts5RJaST/5DSO90woF88XEKoVSWzdXA1+cYgXtZ9lrnSZ/voNQNCc/kNcDWB/9eH8q
         oukXvG+APHr07xXyoiRVnfNAIu0NoRyJO4gRl7kMox10FOdeAVa4C86hGVXEgWIL1z
         DHpeiiUb+PUHWBRHnftozp83wtSCPlDu/KR0wA5Tus7873ErMhZjEh0V/cX/LLr9QJ
         GcvLzWg4JtL3YxsnzXI28YMgDuIhwtNvDRGPXfnFqtov7CBrtU3S5QfdwsKM1K25I6
         WU1k8NIIoVM6w==
Subject: Re: [RESEND PATCH v2 8/9] media: fsl-viu: Constify ioreadX() iomem
 argument (as in generic implementation)
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Ben Skeggs <bskeggs@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Jiang <dave.jiang@intel.com>,
        Jon Mason <jdmason@kudzu.us>, Allen Hubbe <allenbh@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        linux-arch@vger.kernel.org
References: <20200219175007.13627-1-krzk@kernel.org>
 <20200219175007.13627-9-krzk@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1c4a11b5-5ca6-7555-de3c-ff30f707fac7@xs4all.nl>
Date:   Thu, 12 Mar 2020 09:01:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200219175007.13627-9-krzk@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfB1zxMJIE7wElbGm4sdMecyYLJ6LdsDMDpZDeSQuVKwPm0HLBt9h+mOdrGXFuIDkCI9Ox7ukCv0Xr+wsEhOQPNuuqPOa2tbCK6oF1PNdZVqk6thKvC3h
 xE4aE9bNSUWOFhWxTazaeGPVr5hr0AhveAgdpPWZHpjhg5PxgtKgtRwcEM0X31YjusYjKeuEG9QF/4JOHzjohAIjiR+oAI0nyED+Jez9yI4FW1ZB3LXkp8TH
 7MMndY8iJadjMhsV5+oGTHeP7z8vzm/dZU83psQzhxRsPonohHX17/JsKF2l5MFAT9+97UKYOiKAsfrv1Cpys4Ae5wkTvdw4qsE49ssk4hjAoyha0QB9BVju
 9SGy1FrSenK0frRjbC8NaYY9ZERWNSiNH5LA36WXT5yWf3v+Qcv3MkgEimaOp41P2nlVLuOjtsbM7Oc0IE2oIVVfFA700ZJiP3znlyaVddewRuZDpRVP7LaM
 BmiWSHGXgw8YtQmC7z4+FTtlDdPcaOnURURbGtwGqrG9ypYOfWaczdFyon9cFrdpqrNkvqRjWmqFa6YgsB57xqLqvFfcZaXIx/5GPRUQudUCvZPJzisakVQc
 uttKYb/aM3WYuhJM4Wb1Pv6BrMYMIVXGCFsOBd7W/xp0N3iMBGSYj0Aa0rPNR8hHdzbHBC2fjWlNKKBiBqoznNqCGZ0CiVQoEM+QtyRRgiYnx6PeAm5PLOc4
 VNFQmhkOpnD9IFKzOg7MDbXsSwg+OAG64qEuG/VscrSiDVQ1yjv5knp7CxhKGvYM4OpGHYT1Er7Bdx2FCmXu/yAwSbBDRagCD0kotDKUph18wrkxxeFljDJA
 LSc1aSxY7WzE0MoB4x1WWy+jz94FDlyhtSMwiZ6y0dJP3+c2+Q5En242uHE069S9l+7oW8v5MGbWOStqt5f3vSjCb7LIzWN87JmuP89GFWwWLJsughS7GMyf
 9DHMMrFLvERXtynUPrxsXWOFJFYcfPWtUSuDRlT6lyW4OqviXxQxmuwWWPzBiEuN74qNtI+js8zLo4yvgjsgXCeSGNoTx+kuEqyjk5W1UzIpidGK0CRrnVbE
 6hD9Y/vETMZdaCRGTPOlU05njcJF+46w8BJ3SNj0Py3qBk1dX7c6nBfbFypmWYBFmuncdfgfV+GvZgph5pgPHOoQxVCf/tLCrfA6lP3T+1yMX4df+BQFRKLS
 O4WmDF2MxF8KloewGsYz/rsmgB25E6V0YSDc8EvmqseT2P6A01f6bsdZt1AJnufocp+H44s+qhBR6buNUUMphP9KyIyYuNbtmFvkGTyK649jUP2q8Nik1rK1
 3AqiAYrtsks7Dqmq5Qj7chR5DBva/WjXbTAi9lRBeyrc1LiDTAHtFBMmOGm8QJ0PstgU+Qss/H31YuyO+vowQc/YkfqDiEmsIU7MZy0525QlKJCDuomrR9k/
 pt0L69OpaODhDI2GKeTabUJfloUo1rGwDFifFZ3GiczPZsdGrTGULzWF8ZqXdk44Vxmf+o40QJa4goBPwv+YDuim0xPrbohAaaGJnTcviLLAbx0Be2IOpJK7
 066IFrJvKfz7/Wp2S67JJX5FtbO7VF+IrVN/N63uvfJb+FM6hLMjwGqczE7h5AhCTMRfIsHhAU9mTIYVyLN+UBlZ3WL3ahk0SjumGQqE2df8rbpt41Yx3WFA
 IW77guEXBH/AFWkGJEIg2a3N91fXva0TdPJAF0YzlkCOnwCmb9/Naw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/20 6:50 PM, Krzysztof Kozlowski wrote:
> The ioreadX() helpers have inconsistent interface.  On some architectures
> void *__iomem address argument is a pointer to const, on some not.
> 
> Implementations of ioreadX() do not modify the memory under the address
> so they can be converted to a "const" version for const-safety and
> consistency among architectures.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans

> ---
>  drivers/media/platform/fsl-viu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
> index 81a8faedbba6..991d9dc82749 100644
> --- a/drivers/media/platform/fsl-viu.c
> +++ b/drivers/media/platform/fsl-viu.c
> @@ -34,7 +34,7 @@
>  /* Allow building this driver with COMPILE_TEST */
>  #if !defined(CONFIG_PPC) && !defined(CONFIG_MICROBLAZE)
>  #define out_be32(v, a)	iowrite32be(a, (void __iomem *)v)
> -#define in_be32(a)	ioread32be((void __iomem *)a)
> +#define in_be32(a)	ioread32be((const void __iomem *)a)
>  #endif
>  
>  #define BUFFER_TIMEOUT		msecs_to_jiffies(500)  /* 0.5 seconds */
> 

