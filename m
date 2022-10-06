Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC8C5F6726
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiJFNBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiJFNBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:01:43 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C8E8A1FC;
        Thu,  6 Oct 2022 06:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665061302; x=1696597302;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ru6CnBvVhIEhYJCAeuuxpRt9HHeJLOxAuoa9BjBuh8k=;
  b=AGWKWrAmNTte351h2k1feYl2fEi8rMwITVCJk7pNUXa1Ng0fQ3b2azOq
   uKuvJLxK0mA9Tqu3UQrxcvZhNBZH7+ufyXr/eCl51aK2E+6alzDUNMpev
   Nal/AmQePVXxf51aw66W9WRCAYm+XU/TtJLHLlzK0fLBMpvOkNSKnYU6a
   G0RPB2YNDasi333P00LsC+HLiCjUDiLmBkQrJ9Dt5KAHtZ7QeMOcScwI0
   yVVxu3xrA0z8zp+mB6pCuwFd+t1IPnDGoJrgOtk/mfFAE1KbrDX96OsuA
   Q6dzk7SPLhjyK1/yFBt+FIYuNforlaW4X0SnFFSBR/uzfXEGd3cKuEo3f
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="283804515"
X-IronPort-AV: E=Sophos;i="5.95,163,1661842800"; 
   d="scan'208";a="283804515"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 06:01:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="767139765"
X-IronPort-AV: E=Sophos;i="5.95,163,1661842800"; 
   d="scan'208";a="767139765"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga001.fm.intel.com with ESMTP; 06 Oct 2022 06:01:22 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ogQUx-0039Oq-2J;
        Thu, 06 Oct 2022 16:01:11 +0300
Date:   Thu, 6 Oct 2022 16:01:11 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Jan Kara <jack@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        dri-devel@lists.freedesktop.org,
        Andrii Nakryiko <andrii@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-sctp@vger.kernel.org,
        "Md . Haris Iqbal" <haris.iqbal@ionos.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Christoph Hellwig <hch@lst.de>,
        Andy Gospodarek <andy@greyhouse.net>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        ceph-devel@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Nilesh Javali <njavali@marvell.com>,
        Jean-Paul Roubelat <jpr@f6fbb.org>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        linux-nfs@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Andy Lutomirski <luto@kernel.org>, linux-hams@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-raid@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        linux-kernel@vger.kernel.org, Varun Prakash <varun@chelsio.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        netfilter-devel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Jan Kara <jack@suse.com>,
        linux-fsdevel@vger.kernel.org,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        linux-media@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        linux-fbdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Song Liu <song@kernel.org>, Eric Dumazet <edumazet@google.com>,
        target-devel@vger.kernel.org, John Stultz <jstultz@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        drbd-dev@lists.linbit.com, dev@openvswitch.org,
        Leon Romanovsky <leon@kernel.org>,
        Helge Deller <deller@gmx.de>, Hugh Dickins <hughd@google.com>,
        James Smart <james.smart@broadcom.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Julian Anastasov <ja@ssi.bg>, coreteam@netfilter.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        linux-crypto@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        linux-actions@lists.infradead.org,
        Simon Horman <horms@verge.net.au>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Hao Luo <haoluo@google.com>, Theodore Ts'o <tytso@mit.edu>,
        Stephen Boyd <sboyd@kernel.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Florian Westphal <fw@strlen.de>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Jon Maloy <jmaloy@redhat.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Anna Schumaker <anna@kernel.org>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-wireless@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-nvme@lists.infradead.org,
        Michal Januszewski <spock@gentoo.org>,
        linux-mtd@lists.infradead.org, kasan-dev@googlegroups.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Xiubo Li <xiubli@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-rdma@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marco Elver <elver@google.com>,
        Kees Cook <keescook@chromium.org>,
        Yury Norov <yury.norov@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        KP Singh <kpsingh@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Keith Busch <kbusch@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        linux-ext4@vger.kernel.org,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Jeff Layton <jlayton@kernel.org>, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>, linux-mm@kvack.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jack Wang <jinpu.wang@ionos.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        rds-devel@oss.oracle.com, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-scsi@vger.kernel.org, dccp@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Russell King <linux@armlinux.org.uk>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        SHA-cyfmac-dev-list@infineon.com, Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Michael Jamet <michael.jamet@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        linux-block@vger.kernel.org, dmaengine@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jens Axboe <axboe@kernel.dk>, cake@lists.bufferbloat.net,
        brcm80211-dev-list.pdl@broadcom.com,
        Yishai Hadas <yishaih@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linuxppc-dev@lists.ozlabs.org, David Ahern <dsahern@kernel.org>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Vinod Koul <vkoul@kernel.org>,
        tipc-discussion@lists.sourceforge.net, Thomas Graf <tgraf@suug.ch>,
        Johannes Berg <johannes@sipsolutions.net>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: [f2fs-dev] [PATCH v1 3/5] treewide: use get_random_u32() when
 possible
Message-ID: <Yz7Rl7BXamKQhRzH@smile.fi.intel.com>
References: <20221005214844.2699-1-Jason@zx2c4.com>
 <20221005214844.2699-4-Jason@zx2c4.com>
 <20221006084331.4bdktc2zlvbaszym@quack3>
 <Yz7LCyIAHC6l5mG9@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz7LCyIAHC6l5mG9@zx2c4.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 06, 2022 at 06:33:15AM -0600, Jason A. Donenfeld wrote:
> On Thu, Oct 06, 2022 at 10:43:31AM +0200, Jan Kara wrote:

...

> > The code here is effectively doing the
> > 
> > 	parent_group = prandom_u32_max(ngroups);
> > 
> > Similarly here we can use prandom_u32_max(ngroups) like:
> > 
> > 		if (qstr) {
> > 			...
> > 			parent_group = hinfo.hash % ngroups;
> > 		} else
> > 			parent_group = prandom_u32_max(ngroups);
> 
> Nice catch. I'll move these to patch #1.

I believe coccinelle is able to handle this kind of code as well, so Kees'
proposal to use it seems more plausible since it's less error prone and more
flexible / powerful.

-- 
With Best Regards,
Andy Shevchenko


