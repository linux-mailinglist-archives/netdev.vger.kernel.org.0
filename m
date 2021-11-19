Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1288C4572AA
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbhKSQVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:21:44 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:55967 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbhKSQVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:21:44 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MYvPq-1nA5QG1FkO-00Uvnd; Fri, 19 Nov 2021 17:18:40 +0100
Received: by mail-wr1-f52.google.com with SMTP id t30so18984467wra.10;
        Fri, 19 Nov 2021 08:18:39 -0800 (PST)
X-Gm-Message-State: AOAM533M5q/sEYcKQyEF3LD/quH+5tXoxR22dx8S2jjzvTCGjFY54RmH
        QpQ/V3qksWIayQ+EFTLR80yZ1dyBbny7i/GDML0=
X-Google-Smtp-Source: ABdhPJw4+IAppuPXT6q1HxUR8a0gL/2licDTMNOWcd+9ZmouDc8DOwUQvHfxBmUzGfL9Zyvcyrdhh7Hr+rFUCFO4CQE=
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr8790640wrd.369.1637338719490;
 Fri, 19 Nov 2021 08:18:39 -0800 (PST)
MIME-Version: 1.0
References: <20211119113644.1600-1-alx.manpages@gmail.com> <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
 <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com> <CAK8P3a2yVXw9gf8-BNvX_rzectNoiy0MqGKvBcXydiUSrc_fCA@mail.gmail.com>
 <YZfMXlqvG52ls2TE@smile.fi.intel.com>
In-Reply-To: <YZfMXlqvG52ls2TE@smile.fi.intel.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 19 Nov 2021 17:18:23 +0100
X-Gmail-Original-Message-ID: <CAK8P3a06CMzWVj2C3P5v0u8ZVPumXJKrq=TdjSq1NugmeT7-RQ@mail.gmail.com>
Message-ID: <CAK8P3a06CMzWVj2C3P5v0u8ZVPumXJKrq=TdjSq1NugmeT7-RQ@mail.gmail.com>
Subject: Re: [PATCH 00/17] Add memberof(), split some headers, and slightly
 simplify code
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Minyard <cminyard@mvista.com>, Chris Mason <clm@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Sterba <dsterba@suse.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "John S . Gruber" <JohnSGruber@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Kees Cook <keescook@chromium.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Len Brown <lenb@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Intel Graphics <intel-gfx@lists.freedesktop.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:DRM DRIVER FOR QEMU'S CIRRUS DEVICE" 
        <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:nnZxLPDi3vwPCZWHfa1uVcn/9KyQZAdgfeiBxh+Y1Gayx/CTxOz
 Iy2IWiIddQ95Z+Z4aUJFMEjaqom7ATiikfaKZCSnf+UYnokUm56lnWwb/1VDDf9YTDFUTNw
 GcdEqWybmgX7zlFz5oR3hEW3pn5bH8nn6iGb9Nc9krR638Hi1cZfh9XGkLDmw+5cuLBeW9u
 ijTlSmeOMxl0mTRaqHu7A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:l+TZAG2ZkB0=:BC6mG1l44ySPAnomNGBa1r
 ClsvUeYHNqZGfF4wmvjS2OEbZvNKtTiZ8HGSvGzzKzIBEqCVL0la7LLA5Bp22QWhmZnqxQbWQ
 c79vmmMVJ9dRX3rS8Er7fEEaZpkr4lmmMz4mZgLJJuvGs6VNsaHk+UFQIut0rYmoSfdr2diy4
 jpwYC+ogyf34GxWa5uLo81RcvAZDs7w5GFQ2eMP62tq57C4PnLcyduiUAhogIrOcRN2ydVlv7
 1gldqIOZTWTTdtKne2oPiffOhYBgk29VMyRwCc/pPhhLtujEEqW+tqG0IewzByw9KpXGWYm7A
 vAI67r4AS+v6PvEOig8TflZhuhaOC4M991V/nNlhxDS4F96GRslMFgTDaufnk4/QAbfGEAX8J
 zpnevP8ytewPLil7qB5TQics8Zdcn3xXwi741NKSkzUos3dOkYp3oT6VLLWq7P7RIg/mwPpMK
 foH++BkALBeYwlQeNLgbLwkQd2IYoipsBa/EoaM4wFo7mGpmZ3ldyfdYOAJLz/EaDyJJraW9o
 7m9wC5IGbgJWNxSp/KItcwqDAPozAfOhvZIo7PP0dlxmJ72xiYeQmE8b5B3PJptTreVfnCnBO
 MEh1kAGszMarl7gY7lawLXTEjlOfHelZ793UmCkCF5u9QIb3CpmF3Svqr7kPaLSiuaiwYVLFy
 iEQynyKvKjKKOFwWRvjOU7389cX6zx/TEDmDJ7SMgVZlEzm89lK69sMmHXoV+L+/RtT8FT7V0
 66ixBwvbOjU9SqgTb+umiK3JkvqGbrBdgD1/9fa430Bg48I65OxiZzrO+SCj/JjfH8Wz+Ybx4
 sJNk0F6ZPy4qMgTnoPRD2/H/U2il45Fw9LmKEfKQP4FNG5mZG8+EvXETihhgMcbkN8Hdq0q
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 5:10 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Fri, Nov 19, 2021 at 04:57:46PM +0100, Arnd Bergmann wrote:

> > The main problem with this approach is that as soon as you start
> > actually reducing the unneeded indirect includes, you end up with
> > countless .c files that no longer build because they are missing a
> > direct include for something that was always included somewhere
> > deep underneath, so I needed a second set of scripts to add
> > direct includes to every .c file.
>
> Can't it be done with cocci support?

There are many ways of doing it, but they all tend to suffer from the
problem of identifying which headers are actually needed based on
the contents of a file, and also figuring out where to put the extra
#include if there are complex #ifdefs.

For reference, see below for the naive pattern matching I tried.
This is obviously incomplete and partially wrong.

    Arnd

---
#!/bin/bash

GITARGS="$@"
declare HEADER
declare SEARCH
declare FILES
declare OTHERHEADERS

# insert <foo/baz.h> alphabetically after the nearest <foo/bar.h>
insertafter() {
MYFILES=`git grep -l "#include.*<${HEADER%/*}/.*>" $FILES`
if [ -z "$MYFILES" ] ; then return ; fi
MYFILES=`grep -wL $HEADER $FILES`
if [ -z "$MYFILES" ] ; then return ; fi
echo after $HEADER $MYFILES
echo $OTHERHEADERS | tr '[:space:]' '\n' | sort -ru | grep
^${HEADER%/*} | grep -A10000 ^$HEADER | grep -v ^$HEADER | tr / . |
while read i ; do

if [ -z "$MYFILES" ] ; then return ; fi
echo AFTER $i
echo $MYFILES | xargs sed -i '/include.*<'$i'>/ a #include '"<$HEADER>"
MYFILES=`grep -wL $HEADER $MYFILES`
done
}

# insert <foo/bar.h> alphabetically after the nearest <foo/baz.h>
insertbefore() {
MYFILES=`git grep -l "#include.*<${HEADER%/*}/.*>" $FILES`
if [ -z "$MYFILES" ] ; then return ; fi
MYFILES=`grep -wL $HEADER $FILES`
if [ -z "$MYFILES" ] ; then return ; fi
echo before $HEADER $MYFILES
echo $OTHERHEADERS | tr '[:space:]' '\n' | sort -u | grep
^${HEADER%/*} | grep -A10000 ^$HEADER | grep -v ^$HEADER | tr / . |
while read i ; do
if [ -z "$MYFILES" ] ; then return ; fi
echo BEFORE $i
echo $MYFILES | xargs sed -i '/include.*<'$i'>/ i #include '"<$HEADER>"
MYFILES=`grep -wL $HEADER $MYFILES`
done
}

# insert <foo/bar.h> before first <qux/quux.h>
insertcategory() {
MYFILES=`git grep -l "#include.*<.*/.*>" $FILES`
if [ -z "$MYFILES" ] ; then return ; fi
MYFILES=`grep -wL $HEADER $FILES`
if [ -z "$MYFILES" ] ; then return ; fi
for f in $MYFILES ; do
sed -i -e "/^#include.*<.*\/.*>/ { i #include <$HEADER>" -e " ; :L; n;
bL; } " $f
done
}

insertafterlocal() {
MYFILES=`git grep -l "#include.*\".*\"" $FILES`
if [ -z "$MYFILES" ] ; then return ; fi
MYFILES=`grep -wL $HEADER $FILES`
if [ -z "$MYFILES" ] ; then return ; fi
for f in $MYFILES ; do
sed -i -e "/^#include.*\".*\/.*\"/ { a #include <$HEADER>" -e " ; :L;
n; bL; } " $f
done
}

x() {
HEADER="$1"
SEARCH="$2"
echo $HEADER
FILES=`git grep -wl "$SEARCH" | grep -v
"^\(Documentation\|include\|tools\|arch/.*/include\|arch/.*/boot/dts\|scripts\|samples\|arch/*/\(kernel/\|vdso\)\|lib/vdso\)\|classmap.h$"
| grep -v "\.S\>"`
if [ -z "$FILES" ] ; then return ; fi
        FILES=`echo $FILES | xargs grep $HEADER -L `
if [ -z "$FILES" ] ; then return ; fi
OTHERHEADERS=`echo $FILES | xargs grep -h  "include.*\<.*/.*\>" | cut
-f 2 -d\< | cut -f 1 -d \> | grep ^[-_a-zA-Z0-9]*/ ; echo $HEADER`

insertafter
insertbefore
insertcategory
# insertafterlocal
}

# error: implicit declaration of function 'skb_tunnel_rx'
[-Werror,-Wimplicit-function-declaration]
#x linux/debug_locks.h "\(__\|\)debug_locks_off"
#x linux/stat.h
"S_I\(R\|W\|X\)\(USR\|GRP\|OTH\|UGO\)\|S_IRWX\(UGO\|U\|G\|O\)\|S_IALLUGO"
#x linux/stat.h "[A-Z0-9_]*ATTR_\(RW\|RO\|WO\)"
#x linux/dev_printk.h "dev_\(debug\|info\|warn\|err\|notice\|alert\)"
x net/scheduler.h "dev_init_scheduler\|dev_activate"
x linux/sysfs.h
"sysfs_\(create\|remove\|update\|merge\|add_file_to\)_\(\(bin_\|\)file\|file_self\|group\|link\|mount_point\)\(\|s\|_ns\|\)\|sysfs_\(ops\|notify\|chmod_file\|get_dirent\|notify_dirent\|put\)"
x linux/kref.h "kref_get_unless_zero\|kref_get\|kref_init\|kref_read\|kref_put"
x linux/skb_alloc.h
"\(dev\|netdev\|__dev\|__netdev\)_alloc_skb\(\|_ip_align\)\|skb_frag_must_loop\|skb_fill_page_desc\|skb_queue_purge\|skb_rbtree_purge\|netdev_alloc_frag\|skb_frag_address_safe"
x linux/mutex.h
"DEFINE_MUTEX\|\(device\|mutex\|tty\)_\(lock\|unlock\|is_locked\|is_writelocked\)\|usb_\(un\|\)lock_device\|BLOCKING_INIT_NOTIFIER_HEAD\|mutex_init"
x linux/page.h "PAGE_ALIGN\|PAGE_ALIGNED\|dma_map_single\|offset_in_page\|page_address\|virt_to_head_page"
x linux/pgtable.h
"PAGE_\(KERNEL_EXEC\|KERNEL_RO\|KERNEL\|READONLY\)\|pgprot_\(writecombine\|device\|noncached\)"
x linux/if_vlan.h "is_vlan_dev\|vlan_dev_vlan_id\|vlan_get_protocol"
x linux/skb_alloc.h
"skb_frag_must_loop\|\(__\|\)skb_\(fill_page_desc\|queue_purge\|frag_\(address\|ref\|unref_\)\)\|\(__\|\)\(dev\|netdev\|napi\)_alloc_\(page\|pages\|skb\)\|napi_consume_skb\|skb_free_frag"
x linux/gfp.h "__page_frag_cache_drain\|page_frag_alloc"
x linux/skbuff.h "skb_\(copy\|get\|put\)\|skb_queue_[a-z]*"
x linux/iopoll.h
"\(phy_read_mmd\|phy_read\|regmap_field_read\|regmap_read\|read[bwl]\)_poll_timeout\(_atomic\|\)"
x linux/in.h "IPPROTO_\(IP\|TCP\|UDP\|SCTP\)\|struct\ sockaddr_in"
x net/sock.h "\(RCV\|SEND\)_SHUTDOWN\|sk_pacing_shift_update\|sk_capable\|sk_user_ns\|sock_queue_err_skb"
x net/sock.h "SOCKET_I\|\(bh_\|\)\(un\|\)lock_sock\(_nested\|\|_fast\)\|skb_set_owner_w\|skb_orphan_partial"
x linux/bitops.h
"\(__\|\)\(assign\|set\|clear\|test\)_bit\|sign_extend32\|sign_extend64\|for_each_\(set\|clear\)_bit\|get_count_order"
x linux/fs.h "\(un\|\)register_chrdev\(_region\|\)\|compat_ptr_ioctl\|file_clone_open\|filp_open\|filp_close"
x linux/mem_encrypt.h "mem_encrypt_active"
x linux/backlight.h "struct\
\(backlight_ops\|backlight_properties\|backlight_device\)\|backlight_\(enable\|disable\)"
x linux/sched.h "task_pid\(_nr\|\)"
x linux/fb.h "KHZ2PICOS\|PICOS2KHZ\|fb_get_options"
x linux/fcntl.h "O_CLOEXEC\|O_NONBLOCK"
x linux/dma-mapping.h
"\(dma\|dmam\)_\(\(alloc\|free\)_\(coherent\|attrs\)\|\(un\|\)map_\(single\|sg\|page\)\(\_attrs\|\)\)\|dma_set_mask\(_and_coherent\)\|DMA_\(BIT_MASK\|TO_DEVICE\|FROM_DEVICE\|BIDIRECTIONAL\)\|dma_set_max_seg_\(size\|boundary\)\|dma_debug_add_bus"
x linux/file_operations.h
"\(noop\|default\)_llseek\|\(static\|extern\|const\).*struct\
file_operations\|DEFINE_\(SHOW\|SEQ\|DEBUGFS\)_ATTRIBUTE\|iminor\|imajor\|DEFINE_\(SIMPLE\|DEBUGFS\)_ATTRIBUTE\|DEFINE_DRM_[A-Z_]*_FOPS"
x linux/file_operations.h
"\(file\|vm_file\|filp\)->\(private_data\|f_mapping\|f_cred\)\|file_inode"
x linux/bitmap.h
"\(__\|\)bitmap_\(fill\|copy\|zero\|alloc\|zalloc\|and\|or\|xor\|set\|weight\|clear\)"
x linux/mm_types.h "mm->mmap_lock"
x linux/wait.h "\(wait_event\|wake_up\)\(_interruptible\|_killable\|\)\|init_waitqueue_head"
x linux/workqueue.h "DEFINE_STATIC_SRCU\|DEFINE_SRCU\|INIT_WORK"
x linux/timex.h "get_cycles\|random_get_entropy\|struct\
__kernel_timex\|do_adjtimex\|shift_right"
x linux/lockdep.h
"lockdep_assert_irqs_disabled\|lockdep_init_map[_a-z]*\|INIT_DELAYED_WORK"
x linux/kobject_ns.h "kobj_ns_\(drop\|ops\|grab_current\)"
x linux/sched/signal.h "rlimit\(.*\)"
x linux/wait_bit.h
"wake_up_bit\|wait_on_bit\(_timeout\|_io\|_lock\|_lock_io\|_action\|\)\|wait_var_event[a-z_]*"
x linux/io.h "\(__raw_\|\)\(in\|out\|read\|write\)\(b\|w\|l\|q\)\(_p\|_relaxed\|\)\|\(ioread\|iowrite\)\(8\|16\|32\)\(\|_be\)\|wr32\|memset_io"
x linux/mm.h "\(get\|pin\)_user_pages\(_fast\|_locked\|_remote\|unlocked\|\)"
x linux/interrupt.h
"\(free_\|request_\|devm_request_\|enable_\|disable_\)\(threaded_\|\)irq"
x linux/completion.h
"\(re\|\)init_completion\|wait_for_completion\([a-z_]*\)\|struct\
completion\|complete(.*)\|DECLARE_COMPLETION_ONSTACK"
x linux/scatterlist.h
"sg_copy_to_buffer\|sg_nents_for_len\|sg_set_buf\|sg_chain\|sg_pcopy_to_buffer\|for_each_sg\|sg_next\|sg_init_table\|sg_virt\|sg_page\|sg_alloc_table\|sg_set_page\|sg_init_one\|sg_zero_buffer\|sg_dma_page_iter\|for_each_sg_dma_page\|sg_free_table"
x linux/hash.h "hash\(32_ptr\|ptr\|\(_32\|_64\)\(\|_generic\)\)"
x linux/bitmap.h "DECLARE_BITMAP\|bitmap_\(find\|allocate\|release\)_region"
x linux/rwsem.h
"\(up\|down\|downgrade\)_\(read\|write\)\(_killable\|\)\|BLOCKING_INIT_NOTIFIER_HEAD"
x linux/smp.h "get_cpu\|put_cpu\|smp_processor_id"
x linux/if_ether.h "sysfs_format_mac"
x linux/pgtable.h "swapper_pg_dir\|ZERO_PAGE"
x linux/jiffies.h
"jiffies\|get_jiffies_64\|SHIFT_HZ\|jiffies_to_.secs\|preset_lpj\|.secs_to_jiffies"
x linux/page.h "PAGE_ALIGN\|get_page\|put_page\|unpin_user_page\|page_maybe_dma_pinned\|page_to_nid\|page_zone\|page_zonenum\|unpin_user_pages_dirty_lock"
x linux/page.h "PageHighMem"
x linux/pid.h "pid_task\|get_pid\|find_vpid\|find_pid_ns\|put_pid"
x linux/sched.h
"\(wait_event\|wake_up\|wake_up_all\)\(_interruptible\|_killable\|_process\|_timeout\|\)\|current_cred\|kthread_run\|current_euid\|current_user_ns\|lockdep_assert_irqs_disabled"
x linux/of.h "of_parse_phandle[a-z_]*\|of_node->phandle"
x linux/sched/prio.h "MAX_RT_PRIO"
x linux/sched.h "SCHED_FIFO"
x linux/kdev_t.h "\(MINOR\|MAJOR\)(.*)"
x linux/idr.h "\(ida\|idr\)_\(alloc\|simple_get\|find\|for_each[a-z_]*\|destroy\|get_next\|get_cursor\)"
x linux/sched/signal.h "signal_pending"
x linux/math64.h
"\(div_\|div64_\)\(s64\|u64\)\(_rem\|\)\|div64_long\|div64_ul\|DIV64_U64_ROUND_\(UP\|CLOSEST\)\|DIV_ROUND_CLOSEST_ULL\|mul_u64_u32_div"
x linux/eventfd.h "eventfd_\(signal\|ctx_fdget\|ctx_put\)"
x linux/mm.h "find_vma\(_prev\|\)\|put_vaddr_frames\|frame_vector_pages\|frame_vector_to_pages\|frame_vector_destroy\|set_page_dirty\(_lock\|\)\|try_to_release_page\|write_one_page"
x linux/fs.h "AOP_TRUNCATED_PAGE\|AOP_WRITEPAGE_ACTIVATE\|AOP_FLAG_CONT_EXPAND"
x linux/vmalloc.h
"\(vm\|kv\|kvz\)\(free\|alloc\)\|vmalloc_to_page\|is_vmalloc_addr\|dma_map_single\(_attrs\|\)"
x linux/memory.h "high_memory\|virt_addr_valid"
x linux/percpu.h "DEFINE_PER_CPU[A-Z_]*\|per_cpu_ptr"
x linux/percpu-rwsem.h
"DEFINE_PER_CPU[A-Z_]*\|per_cpu_ptr\|percpu_\(down\|up\)_\(read\|write\)\(\|_trylock\)\|percpu_init_rwsem"
x linux/errno.h "EPROBE_DEFER\|EINVAL\|ENOMEM"
x linux/mmap_lock.h
"mmap_\(read\|write\|init\)_\(un\|try\|\)lock\(_non_owner\|_killable\|\)"
x net/net_namespace.h "get_net\|maybe_get_net\|put_net\|check_net\|net_eq"
x linux/nsproxy.h "current->nsproxy\|get_nsproxy\|put_nsproxy"
x linux/sched/task.h "\(put\|get\)_task_struct"
x linux/seq_file.h "seq_open\|single_open\|seq_printf\|seq->private"
x linux/page-flags.h "PG_\(buddy\|lru\|slab\|private\|swapcache\|swapmasked\)"
x linux/crash_core.h "VMCOREINFO_[A-Z]*"
x linux/nodemask.h "\(for_each\|first\)_\(memory_\|online_\|\)node"
x linux/interrupt.h "tasklet_\(init\|schedule\|disable\|enable\|unlock\|kill\)"
x linux/security.h "security_\(path_mknod\|bpf[a-z_]*\)"
x asm/byteorder.h
"\(be\|le\)\(16\|32\|64\)_to_cpu\|cpu_to_\(be\|le\)\(16\|32\|64\)\|\(ntoh\|hton\)\(s\|l\)"
x net/flow_dissector.h "struct flow_keys"
x linux/filter.h "sk_filter\|bpf_dump_raw_ok\|bpf_jit_enable"
x linux/mm.h "truncate_setsize\|truncate_pagecache"
x asm/unaligned.h "\(get\|put\)_unaligned\(\|_le\|_be\)\(16\|32\|64\|\)"
x linux/srcu.h "DEFINE_STATIC_SRCU\|DEFINE_SRCU"
x linux/seq_file_net.h "seq_file_\(single_\|\)net"
x linux/netdevice.h "struct\ napi_struct"
x asm/processor.h "cpu_relax"
x linux/fs.h "deactivate_locked_super\|file_dentry\|alloc_chrdev_region\|init_sync_kiocb\|get_file\|get_dma_buf\|rw_copy_check_uvector"
x linux/spinlock.h
"\(raw_\|arch_\|\)spin_\(try\|un\|\)lock\(_irq\|_irqsave\|_init\|\)\|dsb_sev\|ATOMIC_INIT_NOTIFIER_HEAD\|DEFINE_MUTEX"
x asm/tlbflush.h "flush_tlb_all"
x linux/workqueue.h "\(schedule\|queue\|cancel\)_\(delayed_\|\)work"
x linux/thread_info.h "current->[a-z_]*"
x linux/sched.h "current->[a-z_]*"
x linux/dcache.h "d_backing_dentry\|d_backing_inode\|d_path"
x linux/shrinker.h "register_shrinker\|prealloc_shrinker\|struct\
shrink_control"
x linux/fs_types.h "mapping->i_mmap\(\|rwsem\)"
x linux/fs.h "IOP_\(XATTR\|FASTPERM\|LOOKUP\|NOFOLLOW\|DEFAULT_READLINK\)"
x linux/mm.h "vmf_error\|filemap_fault\|clear_page_dirty_for_io\|vm_operations_struct"
x linux/pagemap.h "read_mapping_page\|read_cache_page\(_gfp\|\)"
x linux/slab.h "ZERO_SIZE_PTR"
x linux/capability.h "capable(.*)"
x linux/mm.h "truncate_inode_page[a-z_]*\|truncate_pageche"
x linux/fs.h "bdevname\|\(un\|\)register_blkdev\|revalidate_disk\|inode_\(un\|\)lock\|i_size_\(write\|read\)\|kill_fasync\|kernel_read_file_from_path"
x linux/fs.h "FMODE_\(WRITE\|READ\|EXEC\)"
x linux/fs_types.h "ATTR_MODE\|struct\ iattr"
x linux/fs_types.h
"\(bd_\|anon_\|\)inode->\(i_uid\|i_gid\|i_mmap\|i_generation\|i_sb\|i_opflags\|i_mmap_rwsem\|i_size\|i_data\|i_mapping\)"
x linux/path.h "path_get\|path_put"
x linux/file_operations.h
"simple_\(read_from_buffer\|write_to_buffer\|open\)\|nonseekable_open"
x linux/spinlock.h
"rwlock_init\|\(read\|write\)_\(lock\|unlock\)\(\|_irq\|\_bh\|_irqsave\)"
x linux/mod_devicetable.h
"\(platform\|of\|dmi\|mdio\|ispnp\|typec\|wmi\|i2c\|i3c\|spi\|slim\|sdio\|input\|pci\|pcmcia\|hda\|pnp\|acpi\|ccw\|ap\|hid\|usb\)_device_id"
x linux/filter.h "struct\ sk_filter\|bpf_compute_data_pointers\|struct bpf_prog"
x linux/if_ether.h "eth_hdr"
x linux/etherdevice.h "ether_addr_copy"
#inet_request_bound_dev_if
x linux/if_addr.h
"IFA_F_PERMANENT\|IFA_F_SECONDARY\|IFA_F_TENTATIVE\|IFA_F_OPTIMISTIC\|IFA_F_DEPRECATED\|IFA_MAX\|IFA_LOCAL\|struct\
ifaddrmsg"
x net/l3mdev.h "l3mdev_master_ifindex_rcu\|inet_sk_bound_l3mdev\|l3mdev_ip6_out"
x net/rtnetlink.h "struct\
rtnl_link_ops\|rtnl_link_register\|rtnl_lock\|MODULE_ALIAS_RTNL_LINK\|RTNL_FLAG_DOIT_UNLOCKED"
x linux/netdevice.h "enum\ tc_setup_type"
x linux/netlink.h "NL_SET_ERR_MSG_MOD"
x net/netlink.h
"nlmsg_parse_deprecated\|nlmsg_\(cancel\|data\|end\|msg_size\|attrlen\)\|nla_data\|nla_get_u32\|nla_put_in6_addr\|nla_total_size"
x linux/if_addrlabel.h "ifaddrlblmsg"
x linux/dcache.h "d_lookup_done\|file_dentry\|d_parent\|dget\|dput\|d_sb"
#inet_sk_bound_l3mdev
x net/netprio_cgroup.h
"sock_update_netprioidx\|task_netprioidx\|struct\ netprio_map"
x linux/device.h "\(get\|put\)_device"
x linux/kernel.h ARRAY_SIZE
x linux/bits.h "BIT(.*)\|GENMASK\|BITS_PER_BYTE"
x linux/of.h "of_get_property\|of_match_node\|of_get_child_by_name\|of_match_ptr\|of_property_read_[a-z0-9_]*"
x linux/pci-dma-compat.h
"PCI_DMA_FROMDEVICE\|PCI_DMA_TODEVICE\|PCI_DMA_NONE\|PCI_DMA_BIDIRECTIONAL\|pci_map_\(single\|sg\|page\)\|pci_\(zalloc\|alloc\|free\)_consistent\|pci_dma_mapping_error\|pci_set_\(dma_mask\|consistent_dma_mask\)"
x asm/compiler.h "__asmeq"
x asm/cpuidle.h "cpu_do_idle"
x crypto/hash.h
"SHASH_DESC_ON_STACK\|crypto_\(shash\|ahash\)_\(digest\|update\)\|ahash_request_set_crypt"
x linux/acpi.h "ACPI_PTR"
x linux/atomic.h
"INIT_WORK\|atomic\(\|64\|_long\)_\(get\|set\|add\|inc\|dec\|sub\|init\)"
x linux/bitops.h
"\(ror\|rol\|hweight\)\(8\|16\|32\|64\)\(fls\|ffs\)\(\|64\|_long\)\|__fls\|__ffs"
x linux/bpf-cgroup.h "bpf_cgroup_[a-z_]*\|cgroup_storage_type"
x linux/cgroup.h "cgroup_id\|task_dfl_cgroup\|cgroup_ancestor"
x linux/cpumask.h
"for_each_\(online\|possible\|present\)_cpu\|cpumask_\(of_node\|of_pci\)\|nr_cpu_ids"
x linux/cpumask.h "num_online_cpus"
x linux/debugobjects.h "debug_object_\(init\|activate\|free\|destroy\)"
x linux/device.h
"device_\(create\|remove\|update\)_\(\(bin_\|\)file\|group\|link\)\(\|s\|_ns\|\)"
x linux/device.h "devm_\(kfree\|kzalloc\|kmalloc\|kcalloc\)"
x linux/err.h "ERR_PTR\|PTR_ERR\|PTR_ERR_OR_ZERO\|IS_ERR\|MAX_ERRNO"
x linux/filter.h "bpf_stats_enabled_key"
x linux/gfp.h "\(__\|\)\(alloc\|free\|get_free\|get_zeroed\)_page\(s\|\)\(_exact\|_node\|\)"
x linux/gfp.h "pm_restore_gfp_mask\|gfpflags_allow_blocking"
x linux/gpio.h "\(devm_\|\)gpio_\(\(set_value\|get_value\)\(_cansleep\|\)\|request\(_one\|\)\|to_irq\|is_valid\|direction_[a-z]*\|free\)"
x linux/gpio/consumer.h
"GPIOD_\(ASIS\|IN\|OUT[A-Z_]*\)\|\(devm_\|\)gpiod_get\(\|_index\|_array\)\(_optional\)\|gpio_\(free\|request\direction_output\|direction_input\)"
x linux/hardirq.h "rcu_nmi_exit"
x linux/i2c.h "struct\ i2c_board_info"
x linux/if_link.h "ifla_vf_info"
x linux/ioctl.h "\(_IO\|_IOR\|_IOW\|_IOWR\)"
x linux/ioprio.h
"get_current_ioprio\|task_nice_io\(class\|prio\)\|init_sync_kiocb"
x linux/kobject.h "\(mm\|kernel\|hypervisor\|fs\)_kobj"
x linux/kobject.h "kernel_kobj"
x linux/kobject.h
"kobject_\(get\|put\|uevent\|get_path\|uevent_env\|set_name\|del\|create\|create_and_add\)\|add_uevent_var"
x linux/log2.h "is_power_of_2\|ilog2"
x linux/math64.h "do_div\|DIV_ROUND_UP_ULL\|DIV_ROUND_DOWN_ULL"
x linux/memcontrol.h "lock_page_memcg\|get_mem_cgroup_from_page\|mem_cgroup_put"
x linux/memory_hotplug.h
"get_online_mems\|put_online_mems\|movable_node_is_enabled\|pfn_to_online_page\|try_online_node"
x linux/mm.h "VMALLOC_START\|VMALLOC_END\|VMALLOC_TOTAL\|unmap_mapping_range\|si_meminfo\|totalram_pages"
x linux/mm.h "VM_READ\|VM_WRITE\|VM_EXEC\|VM_NONE\|VM_SHARED\|VM_DONTDUMP\|VM_DONTEXPAND\|VM_DONTCOPY\|\(io_\|\)remap_pfn_range"
x linux/mm.h "truncate_inode_pages_final\|truncate_inode_pages_range\|vma_pages\|set_page_dirty\|want_init_on_\(alloc\|free\)"
x linux/mmzone.h "MAX_ORDER\|KMALLOC_MAX_SIZE"
x linux/module.h
"MODULE_\(LICENSE\|AUTHOR\|DESCRIPTION\|PARM_DESC\|ALIAS.*\|DEVICE_TABLE\)"
x linux/module.h
"register_module_notifier\|MODULE_STATE_COMING\|MODULE_STATE_GOING\|try_module_get\|lookup_module_symbol_attrs\|lookup_module_symbol_attrs\|module_put\|__module_get"
x linux/notifier.h "struct\
notifier_block\|NOTIFY_DONE\|NOTIFY_OK\|\(atomic\|blocking\|raw\|srcu\)_notifier_chain_\(\(un\|\)register\|call_chain\)\|\(ATOMIC\|BLOCKING\|RAW\)_INIT_NOTIFIER_HEAD"
x linux/of_platform.h
"\(devm_\|\)of_platform_\(populate\|register_reconfig_notifier\|default_populate\|depopulate\)"
x linux/of_platform.h "of_find_device_by_node"
x linux/osq_lock.h "osq_\(lock_init\|lock\|unlock\|is_locked\)"
x linux/pagemap.h "page_endio\|mapping_\(set_\|\)gfp_mask"
x linux/poll.h "poll_wait"
x linux/proc_fs.h "struct\
proc_ops\|proc_mkdir\|proc_create\|remove_proc_\(entry\|file\)"
x linux/ptrace.h "instruction_pointer"
x linux/radix-tree.h "radix_tree_[a-z_]*\|RADIX_TREE_MAX_TAGS"
x linux/random.h "\(get_random_\|prandom\_\)\(u32\|u64\|long\|bytes\)"
x linux/ratelimit.h
"ratelimit_\(state_init\|set_flags\)\|WARN_ON_RATELIMIT\|WARN_RATELIMIT\|pr_[a-z]*_ratelimited"
x linux/rbtree.h
"rb_\(prev\|erase\|link_node\|first\|insert_color\|root\|node\)"
x linux/rbtree_latch.h "latch_tree_[a-z]*"
x linux/rculist.h
"\(list\|__hlist\|hlist\)_\(for_each_[a-z_]*\|next\|first\|tail\|add\|add_tail\|del\|del_init\|entry\)_rcu"
x linux/rcupdate.h "synchronize_rcu"
x linux/rcuwait.h "rcuwait_init\|rcuwait_wait_event"
x linux/regmap.h "regmap_read_poll_timeout\(_atomic\|\)"
x linux/sched.h "TASK_\(\(UN\|\)INTERRUPTIBLE\|NORMAL\|KILLABLE\)"
x linux/sched.h
"cond_resched\|set_current_state\|current->comm\|need_resched\|schedule_timeout\(_killable\|_interruptible\|_idle\|\)\|schedule()"
x linux/sched/pagefault.h "pagefault_\(en\|dis\)able"
x linux/semaphore.h "struct\
semaphore\|down_\(interruptible\|killable\|timeout\|trylock\)\|sema_init"
x linux/seqlock.h "\(__\|raw_\|\)\(read\|write\)_seqcount_begin"
x linux/skbuff.h
"skb_\(push\|pull\|tailroom\|trim\|shinfo\|share_check\|reserve\|queue_[a-z_]*\|headlen\|cloned\)"
x linux/slab.h "\(kfree\|kzalloc\|kmalloc\|kcalloc\)"
x linux/spinlock.h "vcpu_is_preempted"
x linux/string.h
"memcpy\|memcmp\|strcmp\|strncmp\|kmemdup\|memset\|strcat\|strncat\|strlcat\|strstr\|strlen"
x linux/swap.h "mark_page_accessed\|nr_free_buffer_pages"
x linux/swap.h "si_swapinfo\|shrink_all_memory"
x linux/sysctl.h
"proc_do\(string\|\(long\|int\|uint\)vec\)[a-z_]*\|proc_handler\|ctl_table\|register_sysctl[a-z_]*"
x linux/timekeeping.h
"ktime_get[_a-z0-9]*\|ktime_mono_to_real\|JFFS2_NOW\|getboottime64"
x linux/topology.h "cpu_to_node\|node_distance"
x linux/u64_stats_sync.h "u64_stats_\(init\|update_begin\)"
x linux/uaccess.h "\(__\|\)\(get\|put\|copy_from\|copy_to\)_user"
x linux/uprobes.h "uprobe_\(munmap\|mmap\)"
x linux/watch_queue.h
"watch_sizeof\|add_watch_to_object\|put_watch_queue\|remove_watch_list"
x linux/xarray.h "xa_\(alloc\|linux_32b\|erase\|load\|for_each\)\|XA_CHUNK_SIZE"
x net/gro.h "skb_gro_[a-z_0-z]*"
x net/gso.h "skb_gso_[a-z_0-z]*"
x sound/soc-component.h
"snd_soc_component\(_driver\|_set_sysclk\|_set_pll\|\)\|snd_soc_dapm_to_component"
